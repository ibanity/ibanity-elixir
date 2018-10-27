defmodule Ibanity.ResourceOperations do
  alias Ibanity.{BaseResource, Client, Collection, Request}

  def create_by_uri(module, %Request{} = request) do
    request
    |> Client.post
    |> Map.fetch!("data")
    |> wrap_item(module)
  end

  def list_by_uri(module, %Request{} = request) do
    raw_response = Client.get(request)

    items =
      raw_response
      |> Map.fetch!("data")
      |> wrap_items(module)

    Collection.new(module, items, %{}, %{})
  end

  def find_by_uri(module, %Request{} = request) do
    request
    |> Client.get
    |> Map.fetch!("data")
    |> wrap_item(module)
  end

  defp wrap_items(data, module) do
    Enum.map(data, &(BaseResource.new(module, &1)))
  end

  defp wrap_item(data, module) do
    BaseResource.new(module, data)
  end
end