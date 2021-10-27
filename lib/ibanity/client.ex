defmodule Ibanity.Client do
  @moduledoc false

  use Retry
  alias Ibanity.{Collection, Configuration, HttpRequest}
  import Ibanity.JsonDeserializer

  def execute(%Ibanity.Request{} = request, method, uri_path, type \\ nil) do
    case HttpRequest.build(request, method, uri_path) do
      {:ok, http_request} -> execute(http_request, type)
      {:error, reason} -> {:error, reason}
    end
  end

  def get(url, application \\ :default) when is_binary(url) do
    retry with: Configuration.retry_backoff(), rescue_only: [] do
      url
      |> HTTPoison.get!([], options(application))
      |> process_response
    after
      {:ok, response} -> response |> handle_response_body(nil)
    else
      error -> error
    end
  end

  defp execute(%HttpRequest{method: method, application: application} = request, type) do
    body = if method_has_body?(method), do: Jason.encode!(%{data: request.data}), else: ""
    retry with: Configuration.retry_backoff(), rescue_only: [] do
      case HTTPoison.request(
          method,
          request.uri,
          body,
          request.headers,
          options(application)
        )
      do
        {:ok, res} -> res |> process_response
        error      -> error
      end
    after
      {:ok, response} -> response |> handle_response_body(type)
    else
      error -> error
    end
  end

  defp options(application) do
    Keyword.merge([ssl: Configuration.ssl_options(application), hackney: [pool: application]], Configuration.timeout_options())
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

  defp handle_response_body(%{"message" => reason}, _), do: {:error, reason}
  defp handle_response_body({:error, _} = error, _), do: error

  defp handle_response_body({:ok, %{"data" => data, "meta" => meta, "links" => links}}, type)
       when is_list(data) do
    collection =
      data
      |> Enum.map(&deserialize(&1, type))
      |> Collection.new(meta["paging"], links, meta["synchronizedAt"], meta["latestSynchronization"])

    {:ok, collection}
  end

  defp handle_response_body({:ok, %{"data" => data}}, type)
      when is_list(data) do
    collection =
    data
    |> Enum.map(&deserialize(&1, type))
    |> Collection.new(%{}, %{})

    {:ok, collection}
  end

  defp handle_response_body({:ok, %{"data" => data}}, type), do: {:ok, deserialize(data, type)}

  defp handle_response_body({:ok, %{"keys" => keys}}, type)
      when is_list(keys) do
    collection =
      keys
      |> Enum.map(&deserialize(&1, type))
      |> Collection.new(%{}, %{})

    {:ok, collection}
  end

  defp handle_response_body({:ok, %{}}, _), do: {:ok, %{}}
end
