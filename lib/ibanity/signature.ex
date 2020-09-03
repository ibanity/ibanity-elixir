defmodule Ibanity.Signature do
  @moduledoc false

  @empty_sha512sum "z4PhNX7vuL3xVChQ1m2AB9Yg5AULVxXcg_SpIdNs6c5H0NE8XYXysP-DGNKHfuwvY7kxvUdBeoGlODJ6-SfaPg=="
  @algorithm "hs2019"

  alias Ibanity.HttpRequest
  import Ibanity.CryptoUtil

  def signature_headers(%HttpRequest{} = request, method, private_key, certificate_id) do
    parsed_uri = URI.parse(request.uri)
    date = now_to_string()

    headers = [
      Date: date,
      Digest: "SHA-512=" <> payload_digest(request),
      Signature: generate_signature(request, method, parsed_uri, private_key, certificate_id, date)
    ]

    {:ok, headers}
  end

  def signature_headers(uri, method, data, private_key, certificate_id) do
    request = %HttpRequest{
      headers: [Accept: "application/json", "Content-Type": "application/json"],
      uri: uri,
      data: data,
      method: method
    }

    signature_headers(request, method, private_key, certificate_id)
  end

  defp payload_digest(%{data: nil}), do: @empty_sha512sum

  defp payload_digest(request) do
    %{data: request.data}
    |> Jason.encode!()
    |> sha512sum()
  end

  defp generate_signature(request, method, uri, private_key, certificate_id, date) do
    headers = signing_headers(request, method, uri, date)
    timestamp = DateTime.to_unix(DateTime.utc_now())
    signing_headers = headers |> Keyword.keys() |> Enum.join(" ")
    signature = headers |> Enum.join("\n") |> sign(private_key) |> Base.url_encode64()

    [
      ~s/keyId="#{certificate_id}"/,
      ~s/created="#{timestamp}"/,
      ~s/algorithm="#{@algorithm}"/,
      ~s/headers="#{signing_headers}"/,
      ~s/signature="#{signature}"/,
    ] |> Enum.join(", ")
  end

  defp signing_headers(request, method, uri, date) do
    []
    |> add_virtual_header(request, method, uri)
    |> add_host(request, method, uri)
    |> add_digest(request, method, uri)
    |> add_date(date)
    |> add_ibanity_headers(request, method, uri)
    |> add_authorization(request, method, uri)
    |> Enum.reverse()
  end

  defp sign(msg, private_key) do
    :public_key.sign(msg, :sha256, private_key, rsa_padding: :rsa_pkcs1_pss_padding)
  end

  defp add_virtual_header(headers, _request, method, uri) do
    uri_path = if uri.query, do: uri.path <> "?" <> uri.query, else: uri.path
    Keyword.put_new(headers, :"(request-target)", "#{method} #{uri_path}")
  end

  defp add_host(headers, _request, _method, uri) do
    Keyword.put_new(headers, :host, uri.host)
  end

  defp add_digest(headers, request, _method, _uri) do
    Keyword.put_new(headers, :digest, "SHA-512=" <> payload_digest(request))
  end

  defp add_date(headers, date) do
    Keyword.put_new(headers, :date, date)
  end

  defp add_ibanity_headers(headers, request, _method, _uri) do
    ibanity_header? = fn {header, _} ->
      header
      |> Atom.to_string()
      |> String.downcase()
      |> String.starts_with?("ibanity")
    end

    downcase_header = fn {header, value} ->
      {header |> Atom.to_string() |> String.downcase() |> String.to_atom(), value}
    end

    request.headers
    |> Enum.filter(&ibanity_header?.(&1))
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
    DateTime.utc_now()
    |> DateTime.truncate(:second)
    |> DateTime.to_iso8601()
  end
end

defimpl String.Chars, for: Tuple do
  def to_string({key, value}) when is_atom(key) do
    "#{key}: #{value}"
  end
end
