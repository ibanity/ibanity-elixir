defmodule Ibanity.BaseResource do

  def new(module, item, _customer_access_token \\ nil) do
    item_attributes = Map.fetch!(item, "attributes")
    keys = common_keys(item) ++ structure_keys(item_attributes, module)

    struct(module, keys)
  end

  def common_keys(item) do
    [
      id: Map.fetch!(item, "id"),
      self_link: get_in(item, ["links", "self"])
    ]
  end

  def structure_keys(item_attributes, module) do
    module
    |> apply(:keys, [])
    |> Enum.map(&({&1, Map.fetch!(item_attributes, Atom.to_string(&1))}))
  end
end