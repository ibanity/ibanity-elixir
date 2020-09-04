defmodule Ibanity.HttpRequest do
  @moduledoc false

  alias Ibanity.{Configuration, UriUtil}
  import Ibanity.CaseUtil

  defstruct headers: [],
            data: nil,
            uri: nil,
            method: nil,
            return_type: nil,
            application: :default

  def build(%Ibanity.Request{} = request, http_method, uri_path, resource_type \\ nil) do
    case UriUtil.from_request(request, uri_path) do
      {:ok, uri} ->
        request
        |> base_http_request(http_method, uri)
        |> resource_type(resource_type)
        |> add_signature(http_method, Configuration.signature_options(request.application))

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp base_http_request(request, http_method, uri) do
    %__MODULE__{
      application: request.application,
      headers: create_headers(request),
      data: create_data(request),
      method: http_method,
      uri: uri
    }
  end

  defp add_signature(request, _method, nil), do: {:ok, request}

  defp add_signature(request, method, signature_options) do
    with {:ok, private_key} <- Keyword.fetch(signature_options, :signature_key),
         {:ok, certificate_id} <- Keyword.fetch(signature_options, :certificate_id),
         {:ok, headers} <- Ibanity.Signature.signature_headers(request, method, private_key, certificate_id) do
      {:ok, %__MODULE__{request | headers: Keyword.merge(request.headers, headers)}}
    else
      {:error, reason} -> {:error, reason}
      :error -> {:error, :not_found}
    end
  end

  defp resource_type(%__MODULE__{} = request, nil), do: request

  defp resource_type(%__MODULE__{} = request, type) do
    if Map.has_key?(request.data, :type) do
      request
    else
      %__MODULE__{request | data: Map.put(request.data, :type, to_camel(type))}
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
      |> add_meta(request)

    if Enum.empty?(data), do: nil, else: data
  end

  defp add_attributes(data, request) do
    if Enum.empty?(request.attributes) do
      data
    else
      Map.put(data, :attributes, to_camel(request.attributes))
    end
  end

  defp add_type(data, request) do
    if request.resource_type do
      Map.put(data, :type, to_camel(request.resource_type))
    else
      data
    end
  end

  defp add_meta(data, request) do
    if Enum.empty?(request.meta) do
      data
    else
      Map.put(data, :meta, to_camel(request.meta))
    end
  end
end
