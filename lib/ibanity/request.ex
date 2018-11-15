defmodule Ibanity.Request do
  @moduledoc """
  Abstraction layer that eases the construction of an HTTP request.

  Most of the functions come in two flavors. Those with a `Ibanity.Request` as first argument modify return a modified version of it,
  and those without one first create a base `Ibanity.Request` and modify it afterwards.
  The only purpose of this mechanism is to ease the construction of a request.

  Note that all functions of this module return a `Ibanity.Request`.
  None of them can directly fail, and they can therefore be used with the pipe operator.
  """

  @base_headers [
    Accept: "application/json",
    "Content-Type": "application/json"
  ]

  defstruct [
    headers: @base_headers,
    attributes: %{},
    idempotency_key: nil,
    customer_access_token: nil,
    resource_type: nil,
    resource_ids: [],
    limit: nil,
    before: nil,
    after: nil
  ]

  @doc """
  Creates a new request and adds a header to it.

  Same as `header(%Request{}, header, value)`
  """
  def header(header, value), do: header(%__MODULE__{}, header, value)

  @doc """
  Adds a header to a request. Override existing header with the same name if it is present.

  ## Examples

      iex> header(%Request{}, :"X-Http-Dummy", "1708ef66-d37d-4ce0-85d8-6c062863418a")
      %Ibanity.Request{
        headers: [
          Accept: "application/json",
          "Content-Type": "application/json",
          "X-Http-Dummy": "1708ef66-d37d-4ce0-85d8-6c062863418a"
        ],
        ...
      }

      iex> %Request{headers: ["X-Http-Dummy": "1708ef66-d37d-4ce0-85d8-6c062863418a"]}
      ...> |> header(:"X-Http-Dummy", "396c66d5-daf6-48ff-ba4a-58b9be319ec5")
      %Ibanity.Request{
        headers: ["X-Http-Dummy": "396c66d5-daf6-48ff-ba4a-58b9be319ec5"],
        ...
      }
  """
  def header(%__MODULE__{} = request, header, value) do
    %__MODULE__{request | headers: Keyword.put(request.headers, header, value)}
  end

  @doc """
  Creates a new request and adds headers to it.

  Same as `headers(%Request{}, headers)`
  """
  def headers(headers), do: headers(%__MODULE__{}, headers)

  @doc """
  Adds multiple headers to a request, all at once.
  Override existing headers with the same name if they are present.

  ## Examples

      iex> headers(%Request{}, ["X-Dummy1": "1708ef66", "X-Dummy2": "28207dbe"])
      %Ibanity.Request{
        headers: [
          Accept: "application/json",
          "Content-Type": "application/json",
          "X-Dummy1": "1708ef66",
          "X-Dummy2": "28207dbe"
        ],
        ...
      }

      iex> %Request{headers: ["X-Dummy1": "1708ef66", "X-Dummy2": "28207dbe"]}
      ...> |> headers(["X-Dummy1": "1708ef66", "X-Dummy3": "5127d068"])
      %Ibanity.Request{
        headers: [
          "X-Dummy2": "28207dbe",
          "X-Dummy1": "1708ef66",
          "X-Dummy3": "5127d068"
        ],
        ...
      }
  """
  def headers(%__MODULE__{} = request, headers) when is_list(headers) do
    %__MODULE__{request | headers: Keyword.merge(request.headers, headers)}
  end

  @doc """
  Creates a new `Ibanity.Request` and sets the [idempotency key](https://documentation.ibanity.com/api#idempotency) to it
  """
  def idempotency_key(key), do: idempotency_key(%__MODULE__{}, key)

  @doc """
  Sets the [idempotency key](https://documentation.ibanity.com/api#idempotency) to the request
  """
  def idempotency_key(%__MODULE__{} = request, key) when is_binary(key) do
    %__MODULE__{request | idempotency_key: key}
  end

  @doc """
  Creates a new request and sets the [customer access token](https://documentation.ibanity.com/api#customer-access-token) to it
  """
  def customer_access_token(token) when is_binary(token), do: customer_access_token(%__MODULE__{}, token)
  def customer_access_token(%Ibanity.CustomerAccessToken{} = access), do: customer_access_token(access.token)

  @doc """
  Sets the [customer access token](https://documentation.ibanity.com/api#customer-access-token) to the request
  """
  def customer_access_token(%__MODULE__{} = request, %Ibanity.CustomerAccessToken{} = access) do
    customer_access_token(request, access.token)
  end

  @doc """
  Sets the [customer access token](https://documentation.ibanity.com/api#customer-access-token) to the request
  """
  def customer_access_token(%__MODULE__{} = request, token) do
    %__MODULE__{request | customer_access_token: token}
  end

  @doc """
  Creates a new request and adds the attribute and its value to it
  """
  def attribute(attribute, value), do: attribute(%__MODULE__{}, attribute, value)

  @doc """
  Adds an attribute to a request. Overrides existing attribute with the same name
  """
  def attribute(%__MODULE__{} = request, attribute, value) do
    %__MODULE__{request | attributes: Map.put(request.attributes, attribute, value)}
  end

  @doc """
  Creates a new request and adds the attributes and their corresponding value to it, all at once.
  Override existing attributes with the same name
  """
  def attributes(attributes), do: attributes(%__MODULE__{}, attributes)

  @doc """
  Adds the attributes and their corresponding value to the request, all at once.
  Override existing attributes with the same name
  """
  def attributes(%__MODULE__{} = request, attributes) when is_list(attributes) do
    %__MODULE__{request | attributes: Map.merge(request.attributes, Enum.into(attributes, %{}))}
  end

  @doc """
  Creates a new request and sets the resource type to it.
  """
  def resource_type(type), do: resource_type(%__MODULE__{}, type)

  @doc """
  Sets the resource type to the request.
  """
  def resource_type(%__MODULE__{} = request, type) do
    %__MODULE__{request | resource_type: type}
  end

  @doc """
  Creates a new request and sets the `:id` URI identifier.
  It is equivalent to `id(:id, value)`.
  """
  def id(value), do: id(%__MODULE__{}, :id, value)

  @doc """
  Creates a new request and adds an URI identifier to it.
  """
  def id(name, value), do: id(%__MODULE__{}, name, value)

  @doc """
  Sets the `:id` URI identifier.
  It is equivalent to `id(request, :id, value)`.
  """
  def id(%__MODULE__{} = request, value), do: id(request, :id, value)

  @doc """
  Sets the URI identifier to its corresponding value. Overrides existing value if identifier's already present
  """
  def id(%__MODULE__{} = request, name, value) do
    %__MODULE__{request | resource_ids: Keyword.put(request.resource_ids, name, value)}
  end

  @doc """
  Creates a new request and add multiple URI identifiers at once.
  """
  def ids(ids), do: ids(%__MODULE__{}, ids)

  @doc """
  Sets URI template identifiers to their corresponding values. Overrides existing values if identifiers are already present
  """
  def ids(%__MODULE__{} = request, ids) when is_list(ids) do
    %__MODULE__{request | resource_ids: Keyword.merge(request.resource_ids, ids)}
  end

  def limit(max), do: limit(%__MODULE__{}, max)
  @doc """
  Sets the maximum number of items to fetch at once. See [https://documentation.ibanity.com/api#pagination](https://documentation.ibanity.com/api#pagination)
  """
  def limit(%__MODULE__{} = request, max) when is_integer(max) do
    %__MODULE__{request | limit: max}
  end

  def before_id(id), do: before_id(%__MODULE__{}, id)

  @doc """
  Sets the pagination cursor to the given id. See [https://documentation.ibanity.com/api#pagination](https://documentation.ibanity.com/api#pagination)
  """
  def before_id(%__MODULE__{} = request, id) do
    %__MODULE__{request | before: id}
  end

  def after_id(id), do: after_id(%__MODULE__{}, id)

  @doc """
  Sets the pagination cursor to the given id. See [https://documentation.ibanity.com/api#pagination](https://documentation.ibanity.com/api#pagination)
  """
  def after_id(%__MODULE__{} = request, id) do
    %__MODULE__{request | after: id}
  end

  @doc """
  Checks if the request contains a specific id.
  """
  def has_id?(%__MODULE__{} = request, id) do
    Keyword.has_key?(request.resource_ids, id)
  end

  @doc """
  Fetches an id from the request
  """
  def get_id(%__MODULE__{} = request, id) do
    Keyword.get(request.resource_ids, id)
  end

  @doc """
  Checks if the request contains a specific header.
  """
  def has_header?(%__MODULE__{} = request, header) do
    Keyword.has_key?(request.headers, header)
  end

  @doc """
  Fetches a header from the request
  """
  def get_header(%__MODULE__{} = request, header) do
    Keyword.get(request.headers, header)
  end

  def has_customer_access_token?(%__MODULE__{} = request) do
    not is_nil(request.customer_access_token)
  end
end
