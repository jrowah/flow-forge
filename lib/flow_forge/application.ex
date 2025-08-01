defmodule FlowForge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FlowForgeWeb.Telemetry,
      FlowForge.Repo,
      {DNSCluster, query: Application.get_env(:flow_forge, :dns_cluster_query) || :ignore},
      {Oban,
       AshOban.config(
         Application.fetch_env!(:flow_forge, :ash_domains),
         Application.fetch_env!(:flow_forge, Oban)
       )},
      {Phoenix.PubSub, name: FlowForge.PubSub},
      # Start a worker by calling: FlowForge.Worker.start_link(arg)
      # {FlowForge.Worker, arg},
      # Start to serve requests, typically the last entry
      FlowForgeWeb.Endpoint,
      {Absinthe.Subscription, FlowForgeWeb.Endpoint},
      AshGraphql.Subscription.Batcher,
      {AshAuthentication.Supervisor, [otp_app: :flow_forge]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FlowForge.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FlowForgeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
