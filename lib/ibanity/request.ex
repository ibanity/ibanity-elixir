defmodule Ibanity.Request do

  @enforce_keys [:uri]
  defstruct [
    attributes: nil,
    customer_access_token: nil,
    headers: %{},
    idempotency_key: nil,
    payload: %{},
    query_params: %{},
    uri: nil
  ]

  def new(uri), do: %{uri: uri}

  def headers(request, headers), do: Map.put(request, :headers, headers)

  def idempotency_key(request, key), do: Map.put(request, :idempotency_key, key)

  def customer_access_token(request, token), do: Map.put(request, :customer_access_token, token)

  def attributes(request, attributes) do
    create_or_update_data(request, :attributes, attributes)
  end

  def resource_type(request, type) do
    create_or_update_data(request, :resource_type, type)
  end

  def meta(request, meta) do
    create_or_update_data(request, :meta, meta)
  end

  def build(request) do
    request = Map.put_new(request, :payload, %{data: request[:data]})
    struct(__MODULE__, request)
  end

  def create_or_update_data(request, key, value) do
    case Map.has_key?(request, :data) do
      true ->
        update_in(request, [:data], &(Map.put_new(&1, key, value)))
      false ->
        Map.put(request, :data, %{key => value})
    end
  end
end