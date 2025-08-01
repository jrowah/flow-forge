defmodule FlowForge.MixProject do
  use Mix.Project

  def project do
    [
      app: :flow_forge,
      version: "0.1.0",
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps() ++ atulabs_deps(),
      compilers: [:phoenix_live_view] ++ Mix.compilers(),
      listeners: [Phoenix.CodeReloader],
      consolidate_protocols: Mix.env() != :dev,

      # CI
      dialyzer: [
        plt_add_apps: [:ex_unit, :mix],
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ],
      preferred_cli_env: [
        ci: :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.html": :test,
        credo: :test,
        dialyzer: :test,
        sobelow: :test
      ],
      test_coverage: [tool: ExCoveralls],

      # Docs
      name: "FlowForge",
      source_url: "https://github.com/jrowah/flow-forge",
      docs: [main: "README.md", extras: ["README.md", "CHANGELOG.md"], source_ref: "main"],
      releases: [
        flow_forge: [
          version: "0.1.0",
          applications: [flow_forge: :permanent]
        ]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {FlowForge.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bcrypt_elixir, "~> 3.0"},
      {:picosat_elixir, "~> 0.2"},
      {:absinthe_phoenix, "~> 2.0"},
      {:sourceror, "~> 1.8", only: [:dev, :test]},
      {:oban, "~> 2.0"},
      {:tidewave, "~> 0.2", only: [:dev]},
      {:mishka_chelekom, "~> 0.0", only: [:dev]},
      {:live_debugger, "~> 0.3", only: [:dev]},
      {:ash_events, "~> 0.4"},
      {:oban_web, "~> 2.0"},
      {:ash_oban, "~> 0.4"},
      {:ash_admin, "~> 0.13"},
      {:ash_authentication_phoenix, "~> 2.0"},
      {:ash_authentication, "~> 4.0"},
      {:ash_postgres, "~> 2.0"},
      {:ash_graphql, "~> 1.0"},
      {:ash_phoenix, "~> 2.0"},
      {:ash, "~> 3.0"},
      {:igniter, "~> 0.6", only: [:dev, :test]},
      {:phoenix, "~> 1.8.0-rc.4", override: true},
      {:phoenix_ecto, "~> 4.5"},
      {:ecto_sql, "~> 3.13"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 1.1.0-rc.0"},
      {:lazy_html, ">= 0.1.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:esbuild, "~> 0.10", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.3", runtime: Mix.env() == :dev},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.2.0",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:swoosh, "~> 1.16"},
      {:req, "~> 0.5"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.26"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.2.0"},
      {:bandit, "~> 1.5"}
    ]
  end

  defp atulabs_deps do
    [
      {:credo, "~> 1.7", only: :test, runtime: false},
      {:dialyxir, "~> 1.4", only: :test, runtime: false},
      {:doctest_formatter, "~> 0.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:ex_machina, "~> 2.8", only: :test},
      {:excoveralls, "~> 0.18", only: :test},
      {:faker, "~> 0.18", only: :test},
      {:github_workflows_generator, "~> 0.1", only: :dev, runtime: false},
      {:mix_audit, "~> 2.1", only: :test, runtime: false},
      {:sobelow, "~> 0.13", only: [:dev, :test], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: [
        "deps.get",
        "cmd cd assets && npm i -D prettier prettier-plugin-toml",
        "ash.setup",
        "assets.setup",
        "assets.build",
        "run priv/repo/seeds.exs"
      ],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ash.setup --quiet", "test"],
      "assets.setup": [
        "tailwind.install --if-missing",
        "esbuild.install --if-missing",
        "esbuild.install --if-missing"
      ],
      "assets.build": ["tailwind flow_forge", "esbuild flow_forge"],
      "assets.deploy": [
        "tailwind flow_forge --minify",
        "esbuild flow_forge --minify",
        "phx.digest"
      ],
      ci: [
        "deps.unlock --check-unused",
        "deps.audit",
        "hex.audit",
        "sobelow --config .sobelow-conf",
        "format --check-formatted",
        "cmd cd assets && npx prettier -c .",
        "credo --strict",
        "dialyzer",
        "test --cover --warnings-as-errors"
      ],
      prettier: ["cmd cd assets && npx prettier -w ."]
    ]
  end
end
