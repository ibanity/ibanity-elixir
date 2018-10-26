defmodule Ibanity.Client do
  @moduledoc """
  Wrapper for Ibanity API
  """

  alias Ibanity.Request

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

  def get(%Request{} = request) do
    GenServer.call(__MODULE__, {:get, request})
  end

  def post(%Request{} = request) do
    GenServer.call(__MODULE__, {:post, request})
  end

  def patch(%Request{} = request) do
    GenServer.call(__MODULE__, {:patch, request})
  end

  def delete(%Request{} = request) do
    GenServer.call(__MODULE__, {:delete, request})
  end

  def api_schema do
    GenServer.call(__MODULE__, :api_schema)
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

  def handle_call({:get, %Request{} = request}, _, config) do
    res = HTTPoison.get!(
      request.uri,
      build_headers(config),
      ssl: config.ssl_options
    )

    {:reply, Jason.decode!(res.body), config}
  end

  def handle_call({:post, %Request{} = request}, _, config) do
    res = HTTPoison.post!(
      request.uri,
      Jason.encode!(request.payload),
      build_headers(config),
      ssl: config.ssl_options
    )

    {:reply, Jason.decode!(res.body), config}
  end

  def handle_call({:patch, %Request{} = request}, _, config) do
    res = HTTPoison.patch!(
      request.uri,
      Jason.encode!(request.payload),
      build_headers(config),
      ssl: config.ssl_options
    )

    {:reply, Jason.decode!(res.body), config}
  end

  def handle_call({:delete, %Request{} = request}, _, config) do
    res = HTTPoison.delete!(
      request.uri,
      build_headers(config),
      ssl: config.ssl_options
    )

    {:reply, Jason.decode!(res.body), config}
  end

  def handle_call(:api_schema, _, config) do
    {:reply, config.api_schema, config}
  end

  ##
  # Private functions
  ##

  defp build_headers(config) do
    @base_headers
  end
end