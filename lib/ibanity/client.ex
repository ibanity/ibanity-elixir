defmodule Ibanity.Client do
  @moduledoc """
  Wrapper for Ibanity API
  """

  alias Ibanity.Configuration, as: Config
  alias Ibanity.Request

  @base_headers [
    {"Accept", "application/json"},
    {"Content-Type", "application/json"}
  ]

  def get(%Request{} = request) do
    res = HTTPoison.get!(
      request.uri,
      @base_headers,
      ssl: Config.ssl_options()
    )

    Jason.decode!(res.body)
  end

  def post(%Request{} = request) do
    res = HTTPoison.post!(
      request.uri,
      Jason.encode!(request.payload),
      @base_headers,
      ssl: Config.ssl_options()
    )

    Jason.decode!(res.body)
  end

  def patch(%Request{} = request) do
    res = HTTPoison.patch!(
      request.uri,
      Jason.encode!(request.payload),
      @base_headers,
      ssl: Config.ssl_options()
    )

    Jason.decode!(res.body)
  end

  def delete(%Request{} = request) do
    res = HTTPoison.delete!(
      request.uri,
      @base_headers,
      ssl: Config.ssl_options()
    )

    Jason.decode!(res.body)
  end
end