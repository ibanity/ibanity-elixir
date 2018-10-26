defmodule Ibanity.ResourceOperations do
  alias Ibanity.{BaseResource, Client, Collection, Request}

  def create_by_uri(module, %Request{} = request) do
    raw_response = Client.post(request)
  end

  def list_by_uri(module, %Request{} = request) do
    raw_response = Client.get(request)

    items =
      raw_response
      |> Map.fetch!("data")
      |> wrap_items(module)

    Collection.new(module, items, %{}, %{})
  end

  defp wrap_items(data, module) do
    Enum.map(data, &(BaseResource.new(module, &1)))
  end

end