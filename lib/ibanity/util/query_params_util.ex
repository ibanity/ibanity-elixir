#
# Credit: code adapted from the function `Plug.Conn.Query.encode/2`
# from the `elixir-plug` library.
#
defmodule Ibanity.QueryParamsUtil do
  @moduledoc false

  def encode_query([]), do: ""

  def encode_query(query_params) do
    IO.iodata_to_binary(encode_pair("", query_params))
  end

  # covers maps
  defp encode_pair(parent_field, %{} = map) do
    encode_kv(map, parent_field)
  end

  # covers keyword lists
  defp encode_pair(parent_field, list) when is_list(list) and is_tuple(hd(list)) do
    encode_kv(Enum.uniq_by(list, &elem(&1, 0)), parent_field)
  end

  # covers nil
  defp encode_pair(field, nil) do
    [field, ?=]
  end

  # encoder fallback
  defp encode_pair(field, value) do
    [field, ?= | encode_field(value)]
  end

  defp encode_kv(kv, parent_field) do
    mapper = fn
      {_, value} when value in [%{}, [], nil] ->
        []

      {field, value} ->
        field =
          if parent_field == "" do
            encode_field(field)
          else
            parent_field <> "[" <> encode_field(field) <> "]"
          end

        [?&, encode_pair(field, value)]
    end

    kv
    |> Enum.flat_map(mapper)
    |> prune()
  end

  defp encode_field(item) do
    item |> to_string |> URI.encode_www_form()
  end

  defp prune([?& | t]), do: t
  defp prune([]), do: []
end
