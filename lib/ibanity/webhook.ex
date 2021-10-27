defmodule Ibanity.Webhook do
  @moduledoc """
  Creates an Ibanity Event from webhook's payload if signature is valid.
  """

  alias Ibanity.Webhooks.Key

  @default_tolerance 300

  @doc """
  Verify webhook payload and return an Ibanity webhook event.
  `payload` is the raw, unparsed content body sent by Ibanity, which can be
  retrieved with `Plug.Conn.read_body/2`. Note that `Plug.Parsers` will read
  and discard the body, so you must implement a [custom body reader][1] if the
  plug is located earlier in the pipeline.
  `signature` is the value of `Signature` header, which can be fetched
  with `Plug.Conn.get_req_header/2`.
  `tolerance` is the allowed deviation in seconds from the current system time
  to the timestamp found in `signature`. Defaults to 300 seconds (5 minutes).
  [1]: https://hexdocs.pm/plug/Plug.Parsers.html#module-custom-body-reader
  ## Example
      case Ibanity.Webhook.construct_event(payload, signature) do
        {:ok, event} ->
          # Return 200 to Ibanity and handle event
        {:error, reason} ->
          # Reject webhook by responding with non-2XX
      end
  """
  @spec construct_event(String.t(), String.t(), integer) ::
          {:ok, Struct} | {:error, any}
  def construct_event(payload, signature_header, tolerance \\ @default_tolerance) do
    case verify_signature_header(payload, signature_header, tolerance) do
      :ok ->
        {:ok, convert_to_event!(payload)}

      error ->
        error
    end
  end

  def verify_signature_header(payload, signature_header, tolerance \\ @default_tolerance) do
    with {:ok, claims} <- verify_signature(signature_header),
         :ok <- verify_payload(claims["digest"], payload),
         :ok <- validate_timestamp(claims["exp"], tolerance),
         :ok <- verify_issuer(claims["iss"]) do
      :ok
    end
  end

  defp verify_signature(signature_header) do
    case Joken.peek_header(signature_header) do
      {:ok, %{"alg" => alg, "kid" => kid}} ->
        case Key.find(kid) do
          {:ok, %Key{} = signer_key} ->
            signer = Joken.Signer.create(alg, signer_key_map(signer_key))
            Joken.verify(signature_header, signer)

          {:ok, nil} ->
            {:error, "The key id from the header didn't match an available signing key"}

          {:error, _} ->
            {:error, "There was an error retrieving the webhook keys"}
        end

      _ ->
        {:error, "Key details could not be parsed from the signature header"}
    end
  end

  defp verify_payload(digest, payload) do
    if digest == Base.encode64(:crypto.hash(:sha512, payload), case: :lower),
      do: :ok,
      else: {:error, "The payload does not match the signature digest"}
  end

  defp verify_issuer(issuer) do
    if issuer == Ibanity.Configuration.api_url(),
      do: :ok,
      else: {:error, "The signature issuer does not match the configured Ibanity API URL"}
  end

  defp signer_key_map(%Key{} = signer_key) do
    signer_key
    |> Map.from_struct()
    |> Enum.into(%{}, fn {key, value} -> {to_string(key), value} end)
  end

  defp validate_timestamp(timestamp, tolerance) do
    now = System.system_time(:second)
    tolerance_zone = now - tolerance

    if timestamp >= tolerance_zone,
      do: :ok,
      else: {:error, "Timestamp outside the tolerance zone (#{now})"}
  end

  defp convert_to_event!(payload) do
    %{"data" => %{"type" => type} = data} = Jason.decode!(payload)

    Ibanity.JsonDeserializer.deserialize(data, type)
  end
end
