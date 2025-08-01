defmodule GithubWorkflows do
  @moduledoc """
  Used by a custom tool to generate Github workflows.
  Run `mix github_workflows.generate` after updating this module.
  See https://hexdocs.pm/github_workflows_generator.
  """

  def get do
    %{
      "main.yml" => main_workflow(),
      "pr.yml" => pr_workflow()
    }
  end

  defp main_workflow do
    [
      [
        name: "Main",
        on: [
          push: [
            branches: ["main"]
          ]
        ],
        jobs:
          elixir_ci_jobs() ++
            [
              deploy_production_app: deploy_production_app_job()
            ]
      ]
    ]
  end

  defp pr_workflow do
    [
      [
        name: "PR",
        on: [
          pull_request: [
            branches: ["main"],
            types: ["opened", "reopened", "synchronize"]
          ]
        ],
        jobs: elixir_ci_jobs()
      ]
    ]
  end

  defp elixir_ci_jobs do
    [
      compile: compile_job(),
      credo: credo_job(),
      deps_audit: deps_audit_job(),
      dialyzer: dialyzer_job(),
      format: format_job(),
      hex_audit: hex_audit_job(),
      migrations: migrations_job(),
      prettier: prettier_job(),
      sobelow: sobelow_job(),
      test: test_job(),
      unused_deps: unused_deps_job()
    ]
  end

  defp compile_job do
    elixir_job("Install deps and compile",
      steps: [
        [
          name: "Install Elixir dependencies",
          env: [MIX_ENV: "test"],
          run: "mix deps.get"
        ],
        [
          name: "Compile",
          env: [MIX_ENV: "test"],
          run: "mix compile"
        ]
      ]
    )
  end

  defp credo_job do
    elixir_job("Credo",
      needs: :compile,
      steps: [
        [
          name: "Check code style",
          env: [MIX_ENV: "test"],
          run: "mix credo --strict"
        ]
      ]
    )
  end

  defp deploy_job(env, opts) do
    [
      name: "Deploy #{env} app",
      needs: Enum.map(elixir_ci_jobs(), &elem(&1, 0)),
      "runs-on": "ubuntu-latest"
    ] ++ opts
  end

  defp deploy_production_app_job do
    deploy_job("production",
      steps: [
        checkout_step(),
        [
          uses: "superfly/flyctl-actions/setup-flyctl@master"
        ],
        [
          run: "flyctl deploy --remote-only",
          env: [
            FLY_API_TOKEN: "${{ secrets.FLY_API_TOKEN }}",
            POOL_SIZE: "1"
          ]
        ]
      ]
    )
  end

  defp deps_audit_job do
    elixir_job("Deps audit",
      needs: :compile,
      steps: [
        [
          name: "Check for vulnerable Mix dependencies",
          env: [MIX_ENV: "test"],
          run: "mix deps.audit"
        ]
      ]
    )
  end

  defp dialyzer_job do
    cache_key_prefix =
      "${{ runner.os }}-${{ steps.setup-beam.outputs.elixir-version }}-${{ steps.setup-beam.outputs.otp-version }}-plt"

    elixir_job("Dialyzer",
      needs: :compile,
      steps: [
        [
          name: "Restore PLT cache",
          uses: "actions/cache@v3",
          with:
            [
              path: "priv/plts"
            ] ++ cache_opts(cache_key_prefix)
        ],
        [
          name: "Create PLTs",
          env: [MIX_ENV: "test"],
          run: "mix dialyzer --plt"
        ],
        [
          name: "Run dialyzer",
          env: [MIX_ENV: "test"],
          run: "mix dialyzer"
        ]
      ]
    )
  end

  defp elixir_job(name, opts) do
    needs = Keyword.get(opts, :needs)
    services = Keyword.get(opts, :services)
    steps = Keyword.get(opts, :steps, [])

    cache_key_prefix =
      "${{ runner.os }}-${{ steps.setup-beam.outputs.elixir-version }}-${{ steps.setup-beam.outputs.otp-version }}-mix"

    job = [
      name: name,
      "runs-on": "ubuntu-latest",
      steps:
        [
          checkout_step(),
          [
            id: "setup-beam",
            name: "Set up Elixir",
            uses: "erlef/setup-beam@v1",
            with: [
              "version-file": ".tool-versions",
              "version-type": "strict"
            ]
          ],
          [
            uses: "actions/cache@v3",
            with:
              [
                path: ~S"""
                _build
                deps
                """
              ] ++ cache_opts(cache_key_prefix)
          ]
        ] ++ steps
    ]

    job
    |> then(fn job ->
      if needs do
        Keyword.put(job, :needs, needs)
      else
        job
      end
    end)
    |> then(fn job ->
      if services do
        Keyword.put(job, :services, services)
      else
        job
      end
    end)
  end

  defp format_job do
    elixir_job("Format",
      needs: :compile,
      steps: [
        [
          name: "Check Elixir formatting",
          env: [MIX_ENV: "test"],
          run: "mix format --check-formatted"
        ]
      ]
    )
  end

  defp hex_audit_job do
    elixir_job("Hex audit",
      needs: :compile,
      steps: [
        [
          name: "Check for retired Hex packages",
          env: [MIX_ENV: "test"],
          run: "mix hex.audit"
        ]
      ]
    )
  end

  defp migrations_job do
    elixir_job("Migrations",
      needs: :compile,
      services: [
        db: db_service()
      ],
      steps: [
        [
          name: "Setup DB",
          env: [MIX_ENV: "test"],
          run: "mix do ecto.create --quiet, ecto.migrate --quiet"
        ],
        [
          name: "Check if migrations are reversible",
          env: [MIX_ENV: "test"],
          run: "mix ecto.rollback --all --quiet"
        ]
      ]
    )
  end

  defp prettier_job do
    [
      name: "Check formatting using Prettier",
      "runs-on": "ubuntu-latest",
      steps: [
        checkout_step(),
        [
          name: "Restore npm cache",
          uses: "actions/cache@v3",
          id: "npm-cache",
          with: [
            path: "node_modules",
            key: "${{ runner.os }}-prettier"
          ]
        ],
        [
          name: "Install Prettier",
          if: "steps.npm-cache.outputs.cache-hit != 'true'",
          run: "npm i -D prettier prettier-plugin-toml"
        ],
        [
          name: "Run Prettier",
          run: "npx prettier -c ."
        ]
      ]
    ]
  end

  defp sobelow_job do
    elixir_job("Security check",
      needs: :compile,
      steps: [
        [
          name: "Check for security issues using sobelow",
          env: [MIX_ENV: "test"],
          run: "mix sobelow --config .sobelow-conf"
        ]
      ]
    )
  end

  defp test_job do
    elixir_job("Test",
      needs: :compile,
      services: [
        db: db_service()
      ],
      steps: [
        [
          name: "Run tests",
          env: [
            MIX_ENV: "test"
          ],
          run: "mix test --cover --warnings-as-errors"
        ]
      ]
    )
  end

  defp unused_deps_job do
    elixir_job("Check unused deps",
      needs: :compile,
      steps: [
        [
          name: "Check for unused Mix dependencies",
          env: [MIX_ENV: "test"],
          run: "mix deps.unlock --check-unused"
        ]
      ]
    )
  end

  defp db_service do
    [
      image: "postgres:13",
      ports: ["5432:5432"],
      env: [POSTGRES_PASSWORD: "postgres"],
      options:
        "--health-cmd pg_isready --health-interval 10s --health-timeout 5s --health-retries 5"
    ]
  end

  defp checkout_step do
    [
      name: "Checkout",
      uses: "actions/checkout@v4"
    ]
  end

  defp cache_opts(prefix) do
    [
      key: "#{prefix}-${{ github.sha }}",
      "restore-keys": ~s"""
      #{prefix}-
      """
    ]
  end
end
