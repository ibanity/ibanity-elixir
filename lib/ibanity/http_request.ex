defmodule Ibanity.HttpRequest do
  @moduledoc """
  Parameters that will be passed as-is to the HTTP client
  """

  alias Ibanity.{Configuration, UriUtils}

  defstruct [
    headers: [],
    data: nil,
    uri: nil,
    method: nil,
    return_type: nil
  ]

  def build(%Ibanity.Request{} = request, http_method, uri_path, resource_type \\ nil) do
    with {:ok, uri} <- UriUtils.from_request(request, uri_path)
    do
      http_request = %__MODULE__{
        headers: create_headers(request),
        data:    create_data(request),
        method:  http_method,
        uri:     uri
      }

      http_request
      |> resource_type(resource_type)
      |> add_signature(http_method, Configuration.signature_options())
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp add_signature(request, _method, nil), do: {:ok, request}
  defp add_signature(request, method, signature_options) do
    with {:ok, private_key}    <- Keyword.fetch(signature_options, :signature_key),
         {:ok, certificate_id} <- Keyword.fetch(signature_options, :certificate_id),
         {:ok, headers}        <- Ibanity.Signature.signature_headers(request, method, private_key, certificate_id)
    do
      {:ok, %__MODULE__{request | headers: Keyword.merge(request.headers, headers)}}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp resource_type(%__MODULE__{} = request, nil), do: request
  defp resource_type(%__MODULE__{} = request, type) do
    if Map.has_key?(request.data, :type) do
      request
    else
      %__MODULE__{request | data: Map.put(request.data, :type, type)}
    end
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
    data =
      %{}
      |> add_attributes(request)
      |> add_type(request)

    if Enum.empty?(data), do: nil, else: data
  end

  defp add_attributes(data, request) do
    if Enum.empty?(request.attributes) do
      data
    else
      Map.put(data, :attributes, request.attributes)
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
