defmodule Ibanity.ResourceOperations do
  alias Ibanity.{BaseResource, Client, Client.Request, Collection}

  def create_by_uri(%Request{} = request, return_type) do
    case Client.post(request) do
      {:ok, item} ->
        wrap(item, return_type)

      error ->
        error
    end
  end

  def list_by_uri(%Request{} = request, return_type) do
    case Client.get(request) do
      {:ok, items} ->
        items
        |> wrap(return_type)
        |> Collection.new(%{}, %{}, return_type)

      error ->
        error
    end
  end

  def find_by_uri(%Request{} = request, return_type) do
    case Client.get(request) do
      {:ok, item} ->
        wrap(item, return_type)

      error ->
        error
    end
  end

  def update_by_uri(%Request{} = request, return_type) do
    case Client.patch(request) do
      {:ok, item} ->
        wrap(item, return_type)

      error ->
        error
    end
  end

  def destroy_by_uri(%Request{} = request, return_type) do
    case Client.delete(request) do
      {:ok, item} ->
        wrap(item, return_type)

      error ->
        error
    end
  end

  defp wrap(data, return_type) when is_list(data) do
    Enum.map(data, &wrap(&1, return_type))
  end
  defp wrap(data, return_type) do
    BaseResource.new(return_type, data)
  end
end