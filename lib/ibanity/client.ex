defmodule Ibanity.Client do
  @moduledoc """
  Wrapper for Ibanity API
  """

  alias Ibanity.Configuration, as: Config
  alias Ibanity.Request

  defmodule Request do
    defstruct [
      headers: [],
      data: %{},
      query_params: [],
      uri: "",
    ]

    def uri(%__MODULE__{} = request, uri), do: %__MODULE__{request | uri: uri}

    def resource_type(%__MODULE__{} = request, type) do
      unless Map.has_key?(request.data, :type) do
        %__MODULE__{request | data: Map.put(request.data, :type, type)}
      else
        request
      end
    end

    def build(%Ibanity.Request{} = request) do
      %Ibanity.Client.Request{
        headers:     create_headers(request),
        data:        create_data(request),
      }
    end

    defp create_headers(request) do
      request.headers
      |> add_idempotency_key(request)
      |> add_customer_access_token(request)
    end

    defp add_idempotency_key(headers, request) do
      if request.idempotency_key do
        Keyword.put(headers, :"Ibanity-Idempotency-Key", request.idempotency_key)
      else
        headers
      end
    end

    defp add_customer_access_token(headers, request) do
      if request.customer_access_token do
        Keyword.put(headers, :Authorization, "Bearer #{request.customer_access_token}")
      else
        headers
      end
    end

    defp create_data(request) do
      %{}
      |> add_attributes(request)
      |> add_type(request)
    end

    defp add_attributes(data, request) do
      unless Enum.empty?(request.attributes) do
        Map.put(data, :attributes, request.attributes)
      else
        data
      end
    end

    defp add_type(data, request) do
      if request.resource_type do
        Map.put(data, :type, request.resource_type)
      else
        data
      end
    end
  end

  def get(%Request{} = request) do
    res = HTTPoison.get!(
      request.uri,
      request.headers,
      ssl: Config.ssl_options()
    )

    Jason.decode!(res.body)
  end

  def post(%Request{} = request) do
    res = HTTPoison.post!(
      request.uri,
      Jason.encode!(%{data: request.data}),
      request.headers,
      ssl: Config.ssl_options()
    )

    Jason.decode!(res.body)
  end

  def patch(%Request{} = request) do
    res = HTTPoison.patch!(
      request.uri,
      Jason.encode!(%{data: request.data}),
      request.headers,
      ssl: Config.ssl_options()
    )

    Jason.decode!(res.body)
  end

  def delete(%Request{} = request) do
    res = HTTPoison.delete!(
      request.uri,
      request.headers,
      ssl: Config.ssl_options()
    )

    Jason.decode!(res.body)
  end
end