defmodule Ibanity.UriUtils do
  @moduledoc """
  Utilities for URI manipulations
  """

  alias Ibanity.{Configuration, Request}

  @ids_matcher ~r/\{(\w+)\}/

  def from_request(%Request{} = request, uri_path) do
    with {:ok, uri} <- find_uri(uri_path),
         {:ok, uri} <- replace_ids(uri, request.resource_ids)
    do
      encoded_params =
        request
        |> create_query_params
        |> URI.encode_query

      res = if encoded_params == "", do: uri, else: uri <> "?" <> encoded_params

      {:ok, res}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  def replace_ids(uri, resource_ids) do
    expected_ids = Regex.scan(@ids_matcher, uri)
    if all_present?(resource_ids, expected_ids) do
      {:ok, substitute_ids(uri, resource_ids)}
    else
      {:error, :missing_ids}
    end
  end

  defp substitute_ids(uri, ids) do
    Enum.reduce(ids, uri, fn {key, value}, acc ->
      String.replace(acc, "{#{key}}", value)
    end)
  end

  defp all_present?(resource_ids, expected_ids) do
    actual_ids = Keyword.keys(resource_ids)

    missing_ids =
      expected_ids
      |> Enum.map(&List.last/1)
      |> Enum.map(&String.to_atom/1)
      |> Enum.reject(&(Enum.member?(actual_ids, &1)))

    Enum.empty?(missing_ids)
  end

  defp find_uri(uri_path) do
    path = get_in(Configuration.api_schema(), uri_path)
    if path, do: {:ok, path}, else: {:error, :invalid_path}
  end

  defp create_query_params(request) do
    []
    |> add_limit(request)
    |> add_before_id(request)
    |> add_after_id(request)
    |> Enum.reverse
  end

  defp add_limit(params, request) do
    if request.limit, do: Keyword.put(params, :limit, request.limit), else: params
  end

  defp add_before_id(params, request) do
    if request.before, do: Keyword.put(params, :before, request.before), else: params
  end

  defp add_after_id(params, request) do
    if request.after, do: Keyword.put(params, :after, request.after), else: params
  end
end
