defmodule Ibanity.BaseResource do

  @key_paths [
    id: ["id"],
    self_link: ["links", "self"]
  ]

  def new(module, item, _customer_access_token \\ nil) do
    item_attributes = Map.fetch!(item, "attributes")
    keys = common_keys(item) ++ structure_keys(item_attributes, module)

    struct(module, keys)
  end

  def common_keys(item) do
    Enum.reduce(@key_paths, [], fn {key, path}, keys ->
      if get_in(item, path), do: [{key, get_in(item, path)} | keys], else: keys
    end)
  end

  def structure_keys(item_attributes, module) do
    module
    |> apply(:keys, [])
    |> Enum.map(&({&1, Map.fetch!(item_attributes, Atom.to_string(&1))}))
  end
end