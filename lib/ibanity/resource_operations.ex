defmodule Ibanity.ResourceOperations do
  alias Ibanity.{BaseResource, Client, Client.Request, Collection}

  def create(%Request{} = request, return_type) do
    execute_request(:post, request, return_type)
  end

  def list(%Request{} = request, return_type) do
    execute_request(:get, request, return_type)
  end

  def find(%Request{} = request, return_type) do
    execute_request(:get, request, return_type)
  end

  def update(%Request{} = request, return_type) do
    execute_request(:patch, request, return_type)
  end

  def destroy(%Request{} = request, return_type) do
    execute_request(:delete, request, return_type)
  end

  defp execute_request(method, request, return_type) do
    Client
    |> apply(method, [request])
    |> handle_response(return_type)
  end

  defp handle_response({:ok, items}, return_type) when is_list(items) do
    items
    |> wrap(return_type)
    |> Collection.new(%{}, %{}, return_type)
  end
  defp handle_response({:ok, item}, return_type), do: wrap(item, return_type)
  defp handle_response(error, _return_type), do: error

  defp wrap(data, return_type) when is_list(data) do
    Enum.map(data, &wrap(&1, return_type))
  end
  defp wrap(data, return_type) do
    BaseResource.new(return_type, data)
  end
end