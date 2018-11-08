defmodule Ibanity.Client do
  @moduledoc """
  Wrapper for Ibanity API
  """

  alias Ibanity.{Collection, Configuration, HttpRequest}
  import Ibanity.JsonDeserializer

  def execute(%HttpRequest{method: method} = request, return_type) do
    body = if method_has_body?(method), do: Jason.encode!(%{data: request.data}), else: ""
    res = HTTPoison.request!(
      method,
      request.uri,
      body,
      request.headers,
      ssl: Configuration.ssl_options()
    )

    res
    |> IO.inspect
    |> process_response
    |> handle_response_body(return_type)
  end

  defp method_has_body?(method) do
    method == :post or method == :patch
  end

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
        {:error, :unknown_return_code}
    end
  end

  defp handle_response_body(%{"message" => reason}, nil), do: {:error, reason}
  defp handle_response_body({:error, _} = error, _return_type), do: error
  defp handle_response_body({:ok, res}, nil), do: res
  defp handle_response_body({:ok, items}, return_type) when is_list(items) do
    items
    |> deserialize(return_type)
    |> Collection.new(%{}, %{}, return_type)
  end
  defp handle_response_body({:ok, item}, return_type), do: deserialize(item, return_type)

end
