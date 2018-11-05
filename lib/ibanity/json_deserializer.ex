defmodule Ibanity.JsonDeserializer do
  @moduledoc """
  JSON to struct deserializer
  """

  def deserialize(data, return_type) when is_list(data) do
    Enum.map(data, &deserialize(&1, return_type))
  end

  def deserialize(item, return_type) do
    mapping = return_type.key_mapping()
    keys    = Enum.map(mapping, fn {key, path} -> {key, get_in(item, path)} end)

    struct(return_type, keys)
  end
end
