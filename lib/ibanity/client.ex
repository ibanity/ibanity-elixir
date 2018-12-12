defmodule Ibanity.Client do
  @moduledoc false

  alias Ibanity.{Collection, Configuration, HttpRequest}
  import Ibanity.JsonDeserializer

  def execute(%Ibanity.Request{} = request, method, uri_path, parse_response \\ true) do
    case HttpRequest.build(request, method, uri_path) do
      {:ok, http_request} -> execute(http_request, parse_response)
      {:error, reason} -> {:error, reason}
    end
  end

  def get(url, application \\ :default) when is_binary(url) do
    url
    |> HTTPoison.get!([], ssl: Configuration.ssl_options(application))
    |> process_response
    |> handle_response_body
  end

  defp execute(%HttpRequest{method: method, application: application} = request, parse_response) do
    body = if method_has_body?(method), do: Jason.encode!(%{data: request.data}), else: ""

    res =
      HTTPoison.request!(
        method,
        request.uri,
        body,
        request.headers,
        ssl: Configuration.ssl_options(application)
      )

    case parse_response do
      true -> res |> process_response |> handle_response_body
      false -> res
    end
  end

  defp method_has_body?(method) do
    method == :post or method == :patch
  end

  defp process_response(response) do
    code = response.status_code
    body = Jason.decode!(response.body)

    cond do
      code >= 200 and code <= 299 ->
        {:ok, body}

      code >= 400 and code <= 599 ->
        {:error, Map.fetch!(body, "errors")}

      true ->
        {:error, :unknown_return_code}
    end
  end

  defp handle_response_body(%{"message" => reason}), do: {:error, reason}
  defp handle_response_body({:error, _} = error), do: error

  defp handle_response_body({:ok, %{"data" => data, "meta" => meta, "links" => links}})
       when is_list(data) do
    collection =
      data
      |> Enum.map(&deserialize/1)
      |> Collection.new(meta["paging"], links, meta["synchronizedAt"], meta["latestSynchronization"])

    {:ok, collection}
  end

  defp handle_response_body({:ok, %{"data" => data}}), do: {:ok, deserialize(data)}
end
