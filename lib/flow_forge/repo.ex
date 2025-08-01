defmodule FlowForge.Repo do
  use Ecto.Repo,
    otp_app: :flow_forge,
    adapter: Ecto.Adapters.Postgres
end
