defmodule Ibanity.MixProject do
  use Mix.Project

  def project do
    [
      app: :ibanity,
      version: "0.4.0",
      elixir: "~> 1.6",
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
      {:httpoison, "~> 1.4"},
      {:jason, "~> 1.1"},
      {:recase, "~> 0.6.0"},
      {:ex_crypto, "~> 0.9.0"},
      {:retry, "~> 0.11"},
      {:ex_doc, "~> 0.22.1", only: :dev, runtime: false},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false}
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
