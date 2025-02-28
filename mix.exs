defmodule Ibanity.MixProject do
  use Mix.Project

  @source_url "https://github.com/ibanity/ibanity-elixir"

  def project do
    [
      app: :ibanity,
      version: "1.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      description: "Wrapper for the Ibanity API",
      deps: deps(),
      package: package(),
      docs: [
        extras: ["README.md"],
        main: "readme",
        source_url: @source_url,
        groups_for_modules: [
          General: [Ibanity.Request, Ibanity.Collection],
          Webhooks: [
            Ibanity.Webhook,
            Ibanity.WebhookHandler,
            Ibanity.WebhookPlug,
            Ibanity.Webhooks.Key
          ],
          XS2A: [
            ~r/Ibanity\.Xs2a/,
            ~r/Ibanity\.Webhooks\.Xs2a/,
            ~r/Ibanity\.Billing\.Xs2a/,
            ~r/Ibanity\.Reporting.Xs2a/,
            ~r/Ibanity\.Consent/
          ],
          "Ponto Connect": [~r/Ibanity\.PontoConnect/, ~r/Ibanity\.Webhooks\.PontoConnect/],
          Deprecated: ~r/Ibanity\.Sandbox/
        ],
        nest_modules_by_prefix: [
          Ibanity.PontoConnect,
          Ibanity.Xs2a,
          Ibanity.Sandbox,
          Ibanity.Webhooks.PontoConnect,
          Ibanity.Webhooks.Xs2a,
          Ibanity.Reporting.Xs2a,
          Ibanity.Consent,
          Ibanity.Billing
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :retry],
      mod: {Ibanity.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, ">= 1.8.0"},
      {:jason, "~> 1.3"},
      {:recase, "~> 0.7"},
      {:ex_crypto, "~> 0.9.0"},
      {:retry, "~> 0.15"},
      {:joken, "~> 2.4"},
      {:plug, "~> 1.13", optional: true},
      {:mime, "~> 2.0", optional: true},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:credo, "~> 1.7.1", only: [:dev, :test], runtime: false},
      {:plug_cowboy, "~> 2.2"}
    ]
  end

  defp package do
    [
      name: "ibanity",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ibanity/ibanity-elixir"}
    ]
  end
end
