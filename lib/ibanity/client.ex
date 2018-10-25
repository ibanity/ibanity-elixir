defmodule Ibanity.Client do
  @moduledoc """
  Wrapper for Ibanity API
  """

  use GenServer

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

  ##
  # API
  ##

  def start_link do
    GenServer.start_link(__MODULE__, Application.get_all_env(:ibanity))
  end

  def get(uri, query_params \\ %{}, customer_access_token \\ nil, headers \\ nil) do
    GenServer.call(__MODULE__, {:get, uri, query_params, customer_access_token})
  end

  def post(uri, payload, query_params \\ %{}, customer_access_token \\ nil, idempotency_key \\ nil) do
    GenServer.call(__MODULE__, {:post, uri, query_params, customer_access_token, idempotency_key})
  end

  def patch(uri, payload, query_params \\ %{}, customer_access_token \\ nil, idempotency_key \\ nil) do
    GenServer.call(__MODULE__, {:patch, uri, query_params, customer_access_token, idempotency_key})
  end

  def delete(uri, query_params \\ %{}, customer_access_token \\ nil) do
    GenServer.call(__MODULE__, {:delete, uri, query_params, customer_access_token})
  end

  ##
  # Callbacks
  ##

  def init(environment) do
    config = %__MODULE__{
      api_url: Keyword.get(environment, :api_url) || @default_api_url,
      ssl_options: [
        certfile: Keyword.get(environment, :certificate),
        keyfile: Keyword.get(environment, :key),
        cacertfile: Keyword.get(environment, :ssl_ca_file)
      ]
    }

    send(self(), :setup)

    {:ok, config}
  end

  def handle_info(:setup, config) do
    res = HTTPoison.get!(
      config.api_url <> "/",
      build_headers(config),
      ssl: config.ssl_options
    )
    api_schema = res.body |> Jason.decode! |> Map.fetch!("links")

    Process.register(self(), __MODULE__)

    {:noreply, %{config | api_schema: api_schema}}
  end

  def handle_call({:get, uri, query_params, customer_access_token}, _, config) do
    res = HTTPoison.get!(
      uri,
      build_headers(config),
      ssl: config.ssl_options
    )

    {:reply, Jason.decode!(res.body), config}
  end

  def handle_call({:post, uri, payload, query_params, customer_access_token, idempotency_key}, _, config) do
    res = HTTPoison.post!(
      uri,
      Jason.encode!(payload),
      build_headers(config),
      ssl: config.ssl_options
    )

    {:reply, Jason.decode!(res.body), config}
  end

  def handle_call({:patch, uri, payload, query_params, customer_access_token, idempotency_key}, _, config) do
    res = HTTPoison.patch!(
      uri,
      Jason.encode!(payload),
      build_headers(config),
      ssl: config.ssl_options
    )

    {:reply, Jason.decode!(res.body), config}
  end

  def handle_call({:delete, uri, query_params, customer_access_token}, _, config) do
    res = HTTPoison.delete!(
      uri,
      build_headers(config),
      ssl: config.ssl_options
    )

    {:reply, Jason.decode!(res.body), config}
  end

  ##
  # Private functions
  ##

  defp build_headers(config) do
    @base_headers
  end
end