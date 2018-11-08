defmodule Ibanity.Client do
  @moduledoc """
  Wrapper for Ibanity API
  """

  alias Ibanity.{Collection, Configuration, HttpRequest}
  import Ibanity.JsonDeserializer

  def execute(%Ibanity.Request{} = request, method, uri_path, return_type) do
    case HttpRequest.build(request, method, uri_path) do
      {:ok, http_request} -> execute(http_request, return_type)
      {:error, reason}    -> {:error, reason}
    end
  end

  defp execute(%HttpRequest{method: method} = request, return_type) do
    body = if method_has_body?(method), do: Jason.encode!(%{data: request.data}), else: ""
    res = HTTPoison.request!(
      method,
      request.uri,
      body,
      request.headers,
      ssl: Configuration.ssl_options()
    )

    res
    |> process_response
    |> handle_response_body(return_type)
  end

  defp method_has_body?(method) do
    method == :post or method == :patch
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
  defp handle_response_body({:ok, res}, nil), do: {:ok, res}
  defp handle_response_body({:ok, items}, return_type) when is_list(items) do
    collection =
      items
      |> deserialize(return_type)
      |> Collection.new(%{}, %{}, return_type)

    {:ok, collection}
  end
  defp handle_response_body({:ok, item}, return_type), do: {:ok, deserialize(item, return_type)}
end
