defmodule Ibanity.ResourceIdentifier do
  @moduledoc """
  Convenience functions for resource identifier manipulation
  """

  alias Ibanity.Request

  @ids_matcher ~r/\{(\w+)\}/

  def substitute_in_uri(%Request{} = request) do
    expected_ids = Regex.scan(@ids_matcher, request.uri)
    if all_present?(request.resource_ids, expected_ids) do
      {:ok, %Request{request | uri: substitute_ids(request.uri, request.resource_ids)}}
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
end
