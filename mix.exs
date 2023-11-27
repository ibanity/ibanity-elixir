defmodule Ibanity.MixProject do
  use Mix.Project

  def project do
    [
      app: :ibanity,
      version: "1.0.0",
      elixir: "~> 1.15.6",
      start_permanent: Mix.env() == :prod,
      description: "Wrapper for the Ibanity API",
      deps: deps(),
      package: package(),
      docs: [
        extras: ["README.md"],
        main: "readme",
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
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.3"},
      {:recase, "~> 0.7"},
      {:ex_crypto, "~> 0.9.0"},
      {:retry, "~> 0.15"},
      {:joken, "~> 2.4.1"},
      {:plug, "~> 1.13.6", optional: true},
      {:mime, "~> 2.0", optional: true},
      {:ex_doc, "~> 0.29.4", only: :dev, runtime: false},
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
