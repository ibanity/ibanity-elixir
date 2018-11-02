defmodule Ibanity.ResourceOperations do
  @moduledoc """
  Execute the client request and handle the response
  """

  alias Ibanity.{Client, Client.Request, Collection}

  def create(%Request{} = request, return_type \\ nil) do
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

  defp handle_response(%{"message" => reason}, nil), do: {:error, reason}
  defp handle_response({:error, _} = error, _return_type), do: error
  defp handle_response({:ok, res}, nil), do: res
  defp handle_response({:ok, items}, return_type) when is_list(items) do
    items
    |> wrap(return_type)
    |> Collection.new(%{}, %{}, return_type)
  end
  defp handle_response({:ok, item}, return_type), do: wrap(item, return_type)

  defp wrap(data, return_type) when is_list(data) do
    Enum.map(data, &wrap(&1, return_type))
  end
  defp wrap(data, return_type) do
    fill_struct(return_type, data)
  end

  defp fill_struct(module, item) do
    # TODO: Should we use protocol instead of duck typing ?
    # See https://hexdocs.pm/commanded/serialization.html for example
    mapping = module.key_mapping()
    keys    = Enum.map(mapping, fn {key, path} -> {key, get_in(item, path)} end)

    struct(module, keys)
  end
end
