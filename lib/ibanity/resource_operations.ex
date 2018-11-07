defmodule Ibanity.ResourceOperations do
  @moduledoc """
  Execute the client request and handle the response
  """

  alias Ibanity.{Client, HttpRequest, Collection}
  import Ibanity.JsonDeserializer

  def create(%HttpRequest{} = request, return_type \\ nil) do
    execute_request(:post, request, return_type)
  end

  def list(%HttpRequest{} = request, return_type) do
    execute_request(:get, request, return_type)
  end

  def find(%HttpRequest{} = request, return_type) do
    execute_request(:get, request, return_type)
  end

  def update(%HttpRequest{} = request, return_type) do
    execute_request(:patch, request, return_type)
  end

  def destroy(%HttpRequest{} = request, return_type) do
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
    |> deserialize(return_type)
    |> Collection.new(%{}, %{}, return_type)
  end
  defp handle_response({:ok, item}, return_type), do: deserialize(item, return_type)
end
