defmodule Ibanity.Request do
  alias Ibanity.CustomerAccessToken

  @base_headers [
    Accept: "application/json",
    "Content-Type": "application/json"
  ]

  defstruct [
    uri: nil,
    headers: @base_headers,
    attributes: %{},
    idempotency_key: nil,
    customer_access_token: nil,
    resource_type: nil,
    resource_ids: [],
    limit: 10,
    before: nil,
    after: nil
  ]

  def header(header, value), do: header(%__MODULE__{}, header, value)
  def header(%__MODULE__{} = request, header, value) do
    %__MODULE__{request | headers: Keyword.put(request.headers, header, value)}
  end

  def headers(headers), do: headers(%__MODULE__{}, headers)
  def headers(%__MODULE__{} = request, headers) when is_list(headers) do
    %__MODULE__{request | headers: Keyword.merge(request.headers, headers)}
  end

  def idempotency_key(key), do: idempotency_key(%__MODULE__{}, key)
  def idempotency_key(%__MODULE__{} = request, key) when is_binary(key) do
    %__MODULE__{request | idempotency_key: key}
  end

  def customer_access_token(token) when is_binary(token), do: customer_access_token(%__MODULE__{}, token)
  def customer_access_token(%CustomerAccessToken{} = access), do: customer_access_token(access.token)
  def customer_access_token(%__MODULE__{} = request, %CustomerAccessToken{} = access) do
    customer_access_token(request, access.token)
  end
  def customer_access_token(%__MODULE__{} = request, token) do
    %__MODULE__{request | customer_access_token: token}
  end

  def attribute(attribute, value), do: attribute(%__MODULE__{}, attribute, value)
  def attribute(%__MODULE__{} = request, attribute, value) do
    %__MODULE__{request | attributes: Map.put(request.attributes, attribute, value)}
  end

  def attributes(attributes), do: attributes(%__MODULE__{}, attributes)
  def attributes(%__MODULE__{} = request, attributes) when is_list(attributes) do
    %__MODULE__{request | attributes: Map.merge(request.attributes, Enum.into(attributes, %{}))}
  end

  def resource_type(type), do: resource_type(%__MODULE__{}, type)
  def resource_type(%__MODULE__{} = request, type) do
    %__MODULE__{request | resource_type: type}
  end

  def id(name, value), do: id(%__MODULE__{}, name, value)
  def id(%__MODULE__{} = request, name, value) do
    %__MODULE__{request | resource_ids: Keyword.put(request.resource_ids, name, value)}
  end

  def ids(ids), do: ids(%__MODULE__{}, ids)
  def ids(%__MODULE__{} = request, ids) when is_list(ids) do
    %__MODULE__{request | resource_ids: Keyword.merge(request.resource_ids, ids)}
  end

  def has_header?(request, header) do
    Keyword.has_key?(request.headers, header)
  end

  def has_customer_access_token?(request) do
    not is_nil(request.customer_access_token)
  end
end
