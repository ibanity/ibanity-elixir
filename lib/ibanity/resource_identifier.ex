defmodule Ibanity.ResourceIdentifier do
  alias Ibanity.Request

  @ids_matcher ~r/\{(\w+)\}/

  def substitute_in_uri(%Request{} = request) do
    expected_ids = Regex.scan(@ids_matcher, request.uri)
    all_present?(request.resource_ids, expected_ids)

    %Request{request | uri: substitute_ids(request.uri, request.resource_ids)}
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

    if Enum.empty?(missing_ids) do
      resource_ids
    else
      raise ArgumentError, "missing ids: #{inspect missing_ids}"
    end
  end
end
