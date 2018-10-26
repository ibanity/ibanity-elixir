defmodule Ibanity.ResourceOperations do
  alias Ibanity.{BaseResource, Client, Collection}

  def list_by_uri(module, uri, query_params \\ %{}, customer_access_token \\ nil, headers \\ nil) do
    raw_response = Client.get(uri, query_params, headers, customer_access_token)

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