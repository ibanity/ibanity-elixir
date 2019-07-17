defmodule Ibanity.Client do
  @moduledoc false

  use Retry
  alias Ibanity.{Collection, Configuration, HttpRequest}
  import Ibanity.JsonDeserializer

  def execute(%Ibanity.Request{} = request, method, uri_path) do
    case HttpRequest.build(request, method, uri_path) do
      {:ok, http_request} -> execute(http_request)
      {:error, reason} -> {:error, reason}
    end
  end

  def get(url, application \\ :default) when is_binary(url) do
    retry with: Configuration.retry_backoff(), rescue_only: [] do
      url
      |> HTTPoison.get!([], ssl: Configuration.ssl_options(application), hackney: [pool: application])
      |> process_response
    after
      {:ok, response} -> response |> handle_response_body
    else
      error -> error
    end
  end

  defp execute(%HttpRequest{method: method, application: application} = request) do
    body = if method_has_body?(method), do: Jason.encode!(%{data: request.data}), else: ""
    retry with: Configuration.retry_backoff(), rescue_only: [] do
      case HTTPoison.request(
          method,
          request.uri,
          body,
          request.headers,
          ssl: Configuration.ssl_options(application),
          hackney: [pool: application]
        )
      do
        {:ok, res} -> res |> process_response
        error      -> error
      end
    after
      {:ok, response} -> response |> handle_response_body
    else
      error -> error
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
        {:ok, {:ok, body}}

      code >= 400 and code <= 500 ->
        {:ok, {:error, Map.fetch!(body, "errors")}}

      code >= 501 and code <= 599 ->
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

  defp handle_response_body({:ok, %{"data" => data}})
      when is_list(data) do
    collection =
    data
    |> Enum.map(&deserialize/1)
    |> Collection.new(%{}, %{})

    {:ok, collection}
  end

  defp handle_response_body({:ok, %{"data" => data}}), do: {:ok, deserialize(data)}
end
