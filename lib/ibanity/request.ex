defmodule Ibanity.Request do

  @base_headers %{
    :Accept         => "application/json",
    :"Content-Type" => "application/json"
  }

  defstruct [
    headers: @base_headers,
    attributes: %{},
    idempotency_key: nil,
    customer_access_token: nil,
    resource_type: nil,
    resource_id: nil,
    limit: 10,
    before: nil,
    after: nil
  ]


  def new, do: %__MODULE__{}

  def new(attributes) when is_list(attributes) do
    attributes = if attributes, do: Enum.into(attributes, %{}), else: %{}

    %__MODULE__{attributes: attributes}
  end

  def header(%__MODULE__{} = request, header, value) do
    %__MODULE__{request | headers: Map.put(request.headers, header, value)}
  end

  def headers(%__MODULE__{} = request, headers) do
    %__MODULE__{request | headers: Map.merge(request.headers, headers)}
  end

  def idempotency_key(%__MODULE__{} = request, key) do
    %__MODULE__{request | idempotency_key: key}
  end

  def customer_access_token(%__MODULE__{} = request, token) do
    %__MODULE__{request | customer_access_token: token}
  end

  def attribute(%__MODULE__{} = request, attribute, value) do
    %__MODULE__{request | attributes: Map.put(request.attributes, attribute, value)}
  end

  def attributes(%__MODULE__{} = request, attributes) do
    %__MODULE__{request | attributes: Map.merge(request.attributes, attributes)}
  end

  def resource_type(%__MODULE__{} = request, type) do
    %__MODULE__{request | resource_type: type}
  end

  def resource_id(%__MODULE__{} = request, id) do
    %__MODULE__{request | resource_id: id}
  end

  def has_header?(request, header) do
    Map.has_key?(request.headers, header)
  end
end
