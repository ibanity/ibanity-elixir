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

  defstruct application: :default,
            headers: @base_headers,
            attributes: %{},
            meta: %{},
            idempotency_key: nil,
            customer_access_token: nil,
            resource_type: nil,
            resource_ids: [],
            page: %{},
            query_params: %{},
            token: nil

  @doc """
  Sets the application name.

  If no request given, a new `%Ibanity.Request{}` is created.

  ## Examples

      iex> Ibanity.Request.application(%Ibanity.Request{}, :my_app)
      %Ibanity.Request{application: :my_app}

      iex> Ibanity.Request.application(:my_app)
      %Ibanity.Request{application: :my_app}
  """
  def application(request \\ %__MODULE__{}, name)

  def application(%__MODULE__{} = request, name) when is_atom(name) do
    %__MODULE__{request | application: name}
  end

  @doc """
  Adds a header to a request. Override existing header with the same name if it is present.

  If no request given, a new `%Ibanity.Request{}` is created.

  ## Examples

      iex> Ibanity.Request.header(%Ibanity.Request{}, :"X-Http-Dummy", "1708ef66-d37d-4ce0-85d8-6c062863418a")
      %Ibanity.Request{
        headers: [
          "X-Http-Dummy": "1708ef66-d37d-4ce0-85d8-6c062863418a",
          Accept: "application/json",
          "Content-Type": "application/json"
        ]
      }

      iex> %Ibanity.Request{headers: ["X-Http-Dummy": "1708ef66-d37d-4ce0-85d8-6c062863418a"]}
      ...> |> Ibanity.Request.header(:"X-Http-Dummy", "396c66d5-daf6-48ff-ba4a-58b9be319ec5")
      %Ibanity.Request{
        headers: ["X-Http-Dummy": "396c66d5-daf6-48ff-ba4a-58b9be319ec5"]
      }

      iex> Ibanity.Request.header(:"X-Http-Dummy", "1708ef66-d37d-4ce0-85d8-6c062863418a")
      %Ibanity.Request{
        headers: [
          "X-Http-Dummy": "1708ef66-d37d-4ce0-85d8-6c062863418a",
          Accept: "application/json",
          "Content-Type": "application/json"
        ]
      }
  """
  def header(request \\ %__MODULE__{}, header, value)

  def header(%__MODULE__{} = request, header, value) do
    %__MODULE__{request | headers: Keyword.put(request.headers, header, value)}
  end

  @doc """
  Adds multiple headers to a request, all at once.
  Override existing headers with the same name if they are present.

  If no request given, a new `%Ibanity.Request{}` is created.

  ## Examples

      iex> Ibanity.Request.headers(%Ibanity.Request{}, ["X-Dummy1": "1708ef66", "X-Dummy2": "28207dbe"])
      %Ibanity.Request{
        headers: [
          Accept: "application/json",
          "Content-Type": "application/json",
          "X-Dummy1": "1708ef66",
          "X-Dummy2": "28207dbe"
        ]
      }

      iex> %Ibanity.Request{headers: ["X-Dummy1": "1708ef66", "X-Dummy2": "28207dbe"]}
      ...> |> Ibanity.Request.headers(["X-Dummy1": "1708ef66", "X-Dummy3": "5127d068"])
      %Ibanity.Request{
        headers: [
          "X-Dummy2": "28207dbe",
          "X-Dummy1": "1708ef66",
          "X-Dummy3": "5127d068"
        ]
      }

      iex> Ibanity.Request.headers(["X-Dummy1": "1708ef66", "X-Dummy2": "28207dbe"])
      %Ibanity.Request{
        headers: [
          Accept: "application/json",
          "Content-Type": "application/json",
          "X-Dummy1": "1708ef66",
          "X-Dummy2": "28207dbe"
        ]
      }
  """
  def headers(request \\ %__MODULE__{}, headers)

  def headers(%__MODULE__{} = request, headers) when is_list(headers) do
    %__MODULE__{request | headers: Keyword.merge(request.headers, headers)}
  end

  @doc """
  Sets the [idempotency key](https://documentation.ibanity.com/api#idempotency) to the request.

  If no request given, a new `%Ibanity.Request{}` is created.

  ## Examples

      iex> Ibanity.Request.idempotency_key(%Ibanity.Request{}, "6648301f-edb6-4260-aa5d-f9943c76eda9")
      %Ibanity.Request{idempotency_key: "6648301f-edb6-4260-aa5d-f9943c76eda9"}

      iex> Ibanity.Request.idempotency_key("6648301f-edb6-4260-aa5d-f9943c76eda9")
      %Ibanity.Request{idempotency_key: "6648301f-edb6-4260-aa5d-f9943c76eda9"}
  """
  def idempotency_key(request \\ %__MODULE__{}, key)

  def idempotency_key(%__MODULE__{} = request, key) when is_binary(key) do
    %__MODULE__{request | idempotency_key: key}
  end

  @doc """
  Adds the query params and their corresponding values to the request, all at once.
  Overrides existing query params with the same name.

  If no request given, a new `%Ibanity.Request{}` is created.

  ## Examples

      iex> Ibanity.Request.query_params(%Ibanity.Request{}, %{param1: "value1", param2: "value2"})
      %Ibanity.Request{query_params: %{param1: "value1", param2: "value2"}}

      iex> Ibanity.Request.query_params(%Ibanity.Request{}, [{"param1", "value1"}, {"param2", "value2"}])
      %Ibanity.Request{query_params: %{"param1" => "value1", "param2" => "value2"}}

      iex> Ibanity.Request.query_params(%Ibanity.Request{}, [{"param1", "value1"}, {"param2", "value2"}])
      %Ibanity.Request{query_params: %{"param1" => "value1", "param2" => "value2"}}
  """
  def query_params(request \\ %__MODULE__{}, query_params)

  def query_params(%__MODULE__{} = request, query_params) do
    %__MODULE__{
      request
      | query_params: Map.merge(request.query_params, Enum.into(query_params, %{}))
    }
  end

  @doc """
  Sets the customer access token to the request.

  If no request given, a new `%Ibanity.Request{}` is created.

  ## Examples

      iex> Ibanity.Request.customer_access_token(%Ibanity.Request{}, "token123")
      %Ibanity.Request{customer_access_token: "token123"}

      iex> Ibanity.Request.customer_access_token("token123")
      %Ibanity.Request{customer_access_token: "token123"}

      iex> Ibanity.Request.customer_access_token(%Ibanity.Request{}, %Ibanity.Xs2a.CustomerAccessToken{token: "token123"})
      %Ibanity.Request{customer_access_token: "token123"}
  """
  def customer_access_token(request \\ %__MODULE__{}, token)

  def customer_access_token(%__MODULE__{} = request, %Ibanity.Xs2a.CustomerAccessToken{} = access) do
    customer_access_token(request, access.token)
  end

  def customer_access_token(%__MODULE__{} = request, token) when is_binary(token) do
    %__MODULE__{request | customer_access_token: token}
  end

  @doc """
  Sets the token used in some Ponto Connect requests.

  When using a `Ibanity.PontoConnect.Token` struct, the token is already bound to an application, and an application parameter will raise an error.

  If no request given, a new `%Ibanity.Request{}` is created.

  ## Examples

      iex> Ibanity.Request.token(%Ibanity.Request{}, "token123", :my_app)
      %Ibanity.Request{token: "token123", application: :my_app}

      iex> Ibanity.Request.token("token123", :my_app)
      %Ibanity.Request{token: "token123", application: :my_app}

      iex> Ibanity.Request.token("token123")
      %Ibanity.Request{token: "token123", application: :default}

      iex> Ibanity.Request.token(%Ibanity.Request{}, %Ibanity.PontoConnect.Token{access_token: "token123", application: :my_app})
      %Ibanity.Request{token: "token123", application: :my_app}

      iex> Ibanity.Request.token(%Ibanity.PontoConnect.Token{access_token: "token123", application: :my_app})
      %Ibanity.Request{token: "token123", application: :my_app}

      iex> Ibanity.Request.token(%Ibanity.PontoConnect.Token{access_token: "token123", application: :my_app}, :my_app)
      ** (FunctionClauseError) no function clause matching in Ibanity.Request.token/2

      iex> Ibanity.Request.token(%Ibanity.Request{}, %Ibanity.PontoConnect.Token{access_token: "token123", application: :my_app}, :my_app)
      ** (FunctionClauseError) no function clause matching in Ibanity.Request.token/3
  """
  def token(token) do
    token(%__MODULE__{}, token)
  end

  def token(
        %__MODULE__{} = request,
        %Ibanity.PontoConnect.Token{access_token: token, application: token_application}
      ) do
    token(request, token, token_application)
  end

  def token(%__MODULE__{} = request, token) do
    token(request, token, request.application)
  end

  def token(token, application) when is_bitstring(token) or is_nil(token) do
    token(%__MODULE__{}, token, application)
  end

  def token(%__MODULE__{} = request, token, application)
      when is_bitstring(token) or is_nil(token) do
    %__MODULE__{request | token: token, application: application}
  end

  @doc """
  Adds an attribute to a request. Overrides existing attribute with the same name.

  If no request given, a new `%Ibanity.Request{}` is created.

  ## Examples

      iex> Ibanity.Request.attribute(%Ibanity.Request{}, :attr, "value")
      %Ibanity.Request{attributes: %{attr: "value"}}

      iex> Ibanity.Request.attribute(:attr, "value")
      %Ibanity.Request{attributes: %{attr: "value"}}
  """
  def attribute(request \\ %__MODULE__{}, attribute, value)

  def attribute(%__MODULE__{} = request, attribute, value) do
    %__MODULE__{request | attributes: Map.put(request.attributes, attribute, value)}
  end

  @doc """
  Adds the attributes and their corresponding value to the request, all at once. Override existing attributes with the same name.

  If no request given, a new `%Ibanity.Request{}` is created.

  ## Examples

      iex> Ibanity.Request.attributes(%Ibanity.Request{}, [attr1: "value1", attr2: "value2"])
      %Ibanity.Request{attributes: %{attr1: "value1", attr2: "value2"}}

      iex> Ibanity.Request.attributes([attr1: "value1", attr2: "value2"])
      %Ibanity.Request{attributes: %{attr1: "value1", attr2: "value2"}}
  """
  def attributes(request \\ %__MODULE__{}, attributes)

  def attributes(%__MODULE__{} = request, attributes) when is_list(attributes) do
    %__MODULE__{request | attributes: Map.merge(request.attributes, Enum.into(attributes, %{}))}
  end

  def meta(%__MODULE__{} = request, meta) do
    %__MODULE__{request | meta: meta}
  end

  @doc """
  Sets the resource type to the request.

  If no request given, a new `%Ibanity.Request{}` is created.

  ## Examples

      iex> Ibanity.Request.resource_type(%Ibanity.Request{}, :resource)
      %Ibanity.Request{resource_type: :resource}

      iex> Ibanity.Request.resource_type(:resource)
      %Ibanity.Request{resource_type: :resource}
  """
  def resource_type(request \\ %__MODULE__{}, type)

  def resource_type(%__MODULE__{} = request, type) do
    %__MODULE__{request | resource_type: type}
  end

  @doc """
  Sets the `:id` URI identifier if no name is specified, otherwise the given name will be used.

  If no request given, a new `%Ibanity.Request{}` is created.

  ## Examples

      iex> Ibanity.Request.id(%Ibanity.Request{}, "123")
      %Ibanity.Request{resource_ids: [id: "123"]}

      iex> Ibanity.Request.id("123")
      %Ibanity.Request{resource_ids: [id: "123"]}

      iex> Ibanity.Request.id(%Ibanity.Request{}, :my_resource_id, "123")
      %Ibanity.Request{resource_ids: [my_resource_id: "123"]}

      iex> Ibanity.Request.id(:my_resource_id, "123")
      %Ibanity.Request{resource_ids: [my_resource_id: "123"]}
  """
  def id(value) do
    id(%__MODULE__{}, :id, value)
  end

  def id(request_or_name, value) do
    case request_or_name do
      %__MODULE__{} -> id(request_or_name, :id, value)
      name when is_atom(name) -> id(%__MODULE__{}, name, value)
    end
  end

  def id(%__MODULE__{} = request, name, value) when is_atom(name) do
    %__MODULE__{request | resource_ids: Keyword.put(request.resource_ids, name, value)}
  end

  @doc """
  Sets URI template identifiers to their corresponding values. Overrides existing values if identifiers are already present.

  If no request given, a new `%Ibanity.Request{}` is created.

  ## Examples

      iex> Ibanity.Request.ids(%Ibanity.Request{}, %{id1: "value1", id2: "value2"})
      %Ibanity.Request{resource_ids: [id1: "value1", id2: "value2"]}

      iex> Ibanity.Request.ids(%Ibanity.Request{}, [id1: "value1", id2: "value2"])
      %Ibanity.Request{resource_ids: [id1: "value1", id2: "value2"]}

      iex> Ibanity.Request.ids(%{id1: "value1", id2: "value2"})
      %Ibanity.Request{resource_ids: [id1: "value1", id2: "value2"]}

      iex> Ibanity.Request.ids([id1: "value1", id2: "value2"])
      %Ibanity.Request{resource_ids: [id1: "value1", id2: "value2"]}
  """
  def ids(request \\ %__MODULE__{}, ids)

  def ids(%__MODULE__{} = request, ids) when is_map(ids) do
    ids_keyword_list = Enum.into(ids, [])
    ids(request, ids_keyword_list)
  end

  def ids(%__MODULE__{} = request, ids) when is_list(ids) do
    %__MODULE__{request | resource_ids: Keyword.merge(request.resource_ids, ids)}
  end

  @doc """
  Sets the maximum number of items to fetch at once. See [https://documentation.ibanity.com/api#pagination](https://documentation.ibanity.com/api#pagination).

  If no request given, a new `%Ibanity.Request{}` is created.

  ## Examples

      iex> Ibanity.Request.limit(%Ibanity.Request{}, 10)
      %Ibanity.Request{page: %{limit: 10}}

      iex> Ibanity.Request.limit(10)
      %Ibanity.Request{page: %{limit: 10}}
  """
  def limit(request \\ %__MODULE__{}, max)

  def limit(%__MODULE__{} = request, max) when is_integer(max) do
    %__MODULE__{request | page: Map.merge(request.page, %{limit: max})}
  end

  @doc """
  Sets the page of results to fetch using page-based pagination. See [https://documentation.ibanity.com/api#page-based-pagination](https://documentation.ibanity.com/api#page-based-pagination).

  If no request given, a new `%Ibanity.Request{}` is created.

  ## Examples

      iex> Ibanity.Request.page_number(%Ibanity.Request{}, 2)
      %Ibanity.Request{page: %{number: 2}}

      iex> Ibanity.Request.page_number(2)
      %Ibanity.Request{page: %{number: 2}}
  """
  def page_number(request \\ %__MODULE__{}, value)

  def page_number(%__MODULE__{} = request, value) when is_integer(value) do
    %__MODULE__{request | page: Map.merge(request.page, %{number: value})}
  end

  @doc """
  Sets the maximum number of results to fetch per page. See [https://documentation.ibanity.com/api#page-based-pagination](https://documentation.ibanity.com/api#page-based-pagination).

  If no request given, a new `%Ibanity.Request{}` is created.

  ## Examples

      iex> Ibanity.Request.page_size(%Ibanity.Request{}, 50)
      %Ibanity.Request{page: %{size: 50}}

      iex> Ibanity.Request.page_size(50)
      %Ibanity.Request{page: %{size: 50}}
  """
  def page_size(request \\ %__MODULE__{}, value)

  def page_size(%__MODULE__{} = request, value) when is_integer(value) do
    %__MODULE__{request | page: Map.merge(request.page, %{size: value})}
  end

  @doc """
  Sets the pagination cursor to the given id. See [https://documentation.ibanity.com/api#pagination](https://documentation.ibanity.com/api#pagination).

  If no request given, a new `%Ibanity.Request{}` is created.

  ## Examples

      iex> Ibanity.Request.before_id(%Ibanity.Request{}, "123")
      %Ibanity.Request{page: %{before: "123"}}

      iex> Ibanity.Request.before_id("123")
      %Ibanity.Request{page: %{before: "123"}}
  """
  def before_id(request \\ %__MODULE__{}, id)

  def before_id(%__MODULE__{} = request, id) do
    %__MODULE__{request | page: Map.merge(request.page, %{before: id})}
  end

  @doc """
  Sets the pagination cursor to the given id. See [https://documentation.ibanity.com/api#pagination](https://documentation.ibanity.com/api#pagination).

  If no request given, a new `%Ibanity.Request{}` is created.

  ## Examples

      iex> Ibanity.Request.after_id(%Ibanity.Request{}, "123")
      %Ibanity.Request{page: %{after: "123"}}

      iex> Ibanity.Request.after_id("123")
      %Ibanity.Request{page: %{after: "123"}}
  """
  def after_id(request \\ %__MODULE__{}, id)

  def after_id(%__MODULE__{} = request, id) do
    %__MODULE__{request | page: Map.merge(request.page, %{after: id})}
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
