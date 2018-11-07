defmodule Ibanity.Client do
  @moduledoc """
  Wrapper for Ibanity API
  """

  alias Ibanity.{Configuration, HttpRequest}

  def get(%HttpRequest{} = request) do
    res = HTTPoison.get!(
      request.uri,
      request.headers,
      ssl: Configuration.ssl_options()
    )

    process_response(res)
  end

  def post(%HttpRequest{} = request) do
    res = HTTPoison.post!(
      request.uri,
      Jason.encode!(%{data: request.data}),
      request.headers,
      ssl: Configuration.ssl_options()
    )

    process_response(res)
  end

  def patch(%HttpRequest{} = request) do
    res = HTTPoison.patch!(
      request.uri,
      Jason.encode!(%{data: request.data}),
      request.headers,
      ssl: Configuration.ssl_options()
    )

    process_response(res)
  end

  def delete(%HttpRequest{} = request) do
    res = HTTPoison.delete!(
      request.uri,
      request.headers,
      ssl: Configuration.ssl_options()
    )

    process_response(res)
  end

  defp process_response(response) do
    code = response.status_code
    body = Jason.decode!(response.body)

    cond do
      code >= 200 and code <= 299 ->
        {:ok, Map.fetch!(body, "data")}
      code >= 400 and code <= 599 ->
        {:error, Map.fetch!(body, "errors")}
      true ->
        raise "Unknown return code: #{code}"
    end
  end
end
