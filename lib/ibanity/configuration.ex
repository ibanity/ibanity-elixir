defmodule Ibanity.Configuration do
  use Agent

  defstruct [
    api_schema: nil,
    api_url: nil,
    ssl_options: nil,
  ]

  @default_api_url "https://api.ibanity.com:443"

  @base_headers [
    {"Accept", "application/json"},
    {"Content-Type", "application/json"}
  ]

  def start_link(environment) do
    Agent.start_link(fn -> init(environment) end, name: __MODULE__)
  end

  def ssl_options, do: Agent.get(__MODULE__, &(&1.ssl_options))

  def api_schema, do: Agent.get(__MODULE__, &(&1.api_schema))

  defp init(environment) do
    config = %__MODULE__{
      api_url: Keyword.get(environment, :api_url) || @default_api_url,
      ssl_options: [
        certfile: Keyword.get(environment, :certificate),
        keyfile: Keyword.get(environment, :key),
        cacertfile: Keyword.get(environment, :ssl_ca_file)
      ]
    }

    res = HTTPoison.get!(
      config.api_url <> "/",
      @base_headers,
      ssl: config.ssl_options
    )
    api_schema = res.body |> Jason.decode! |> Map.fetch!("links")

    %{config | api_schema: api_schema}
  end
end