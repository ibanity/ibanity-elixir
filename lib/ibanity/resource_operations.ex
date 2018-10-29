defmodule Ibanity.ResourceOperations do
  alias Ibanity.{BaseResource, Client, Client.Request, Collection}

  def create_by_uri(%Request{} = request, return_type) do
    request
    |> Client.post
    |> Map.fetch!("data")
    |> wrap_item(return_type)
  end

  def list_by_uri(%Request{} = request, return_type) do
    raw_response = Client.get(request)

    items =
      raw_response
      |> Map.fetch!("data")
      |> wrap_items(return_type)

    Collection.new(return_type, items, %{}, %{})
  end

  def find_by_uri(%Request{} = request, return_type) do
    request
    |> Client.get
    |> Map.fetch!("data")
    |> wrap_item(return_type)
  end

  def update_by_uri(%Request{} = request, return_type) do
    request
    |> Client.patch
    |> Map.fetch!("data")
    |> wrap_item(return_type)
  end

  def destroy_by_uri(%Request{} = request, return_type) do
    request
    |> Client.delete
    |> Map.fetch!("data")
    |> wrap_item(return_type)
  end

  defp wrap_items(data, return_type) do
    Enum.map(data, &(BaseResource.new(return_type, &1)))
  end

  defp wrap_item(data, return_type) do
    BaseResource.new(return_type, data)
  end
end