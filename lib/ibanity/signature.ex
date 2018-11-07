defmodule Ibanity.Signature do
  @moduledoc """
  HTTP Signature: https://documentation.ibanity.com/products#http-signature
  """

  @empty_sha512sum "z4PhNX7vuL3xVChQ1m2AB9Yg5AULVxXcg_SpIdNs6c5H0NE8XYXysP-DGNKHfuwvY7kxvUdBeoGlODJ6-SfaPg=="
  @empty_sha256sum "RBNvo1WzZ4oRRq0W9-hknpT7T8If536DEMBg9hyq_4o="
  @algorithm "rsa-sha256"

  alias Ibanity.Client.Request, as: ClientRequest

  def signature_headers(%ClientRequest{} = request, method, uri, private_key, certificate_id) do
    uri = URI.parse(uri)

    [
      "Date": now_to_string(),
      "Digest":  "SHA-256=" <> payload_digest(request),
      "Signature": generate_signature(request, method, uri, private_key, certificate_id)
    ]
  end

  defp payload_digest(%{data: nil}), do: @empty_sha256sum
  defp payload_digest(request) do
    %{data: request.data}
    |> Jason.encode!
    |> Ibanity.CryptoUtils.sha256sum
  end

  defp generate_signature(request, method, uri, private_key, certificate_id) do
    headers         = signing_headers(request, method, uri)
    signing_headers = headers |> Keyword.keys |> Enum.join(" ")
    signature       = headers |> Enum.join("\n") |> sign(private_key) |> Base.url_encode64

    "keyId=\"#{certificate_id}\" algorithm=\"#{@algorithm}\" headers=\"#{signing_headers}\" signature=\"#{signature}\""
  end

  defp signing_headers(request, method, uri) do
    []
    |> add_virtual_header(request, method, uri)
    |> add_host(request, method, uri)
    |> add_digest(request, method, uri)
    |> add_date(request, method, uri)
    |> add_ibanity_headers(request, method, uri)
    |> add_authorization(request, method, uri)
    |> Enum.reverse
  end

  defp sign(msg, private_key) do
    {:ok, signature} = ExPublicKey.sign(msg, :sha256, private_key)
    signature
  end

  defp add_virtual_header(headers, _request, method, uri) do
    Keyword.put_new(headers, :"(request-target)", "#{method} #{uri.path}")
  end

  defp add_host(headers, _request, _method, uri) do
    Keyword.put_new(headers, :host, uri.host)
  end

  defp add_digest(headers, request, _method, _uri) do
    Keyword.put_new(headers, :digest, "SHA-256=" <> payload_digest(request))
  end

  defp add_date(headers, _request, _method, _uri) do
    Keyword.put_new(headers, :date, now_to_string())
  end

  defp add_ibanity_headers(headers, request, _method, _uri) do
    ibanity_header? = fn {header, _} ->
      header
      |> Atom.to_string
      |> String.downcase
      |> String.starts_with?("ibanity")
    end

    downcase_header = fn {header, value} ->
      {header |> Atom.to_string |> String.downcase |> String.to_atom, value}
    end

    request.headers
    |> Enum.filter(&(ibanity_header?.(&1)))
    |> Enum.map(&downcase_header.(&1))
    |> Keyword.merge(headers)
  end

  defp add_authorization(headers, request, _method, _uri) do
    if Keyword.has_key?(request.headers, :Authorization) do
      Keyword.put_new(headers, :authorization, Keyword.get(request.headers, :Authorization))
    else
      headers
    end
  end

  defp now_to_string do
    DateTime.utc_now
    |> DateTime.truncate(:second)
    |> DateTime.to_iso8601
  end
end

defimpl String.Chars, for: Tuple do
  def to_string({key, value}) when is_atom(key) do
    "#{key}: #{value}"
  end
end
