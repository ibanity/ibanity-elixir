defmodule Ibanity.Webhook do
  @moduledoc """
  Creates an Ibanity Event from webhook's payload if signature is valid.
  """

  alias Ibanity.Webhooks.Key

  @default_tolerance 30

  @doc """
  Verify webhook payload and return an Ibanity webhook event.
  `payload` is the raw, unparsed content body sent by Ibanity, which can be
  retrieved with `Plug.Conn.read_body/2`. Note that `Plug.Parsers` will read
  and discard the body, so you must implement a [custom body reader][1] if the
  plug is located earlier in the pipeline.
  `signature_header` is the value of `Signature` header, which can be fetched
  with `Plug.Conn.get_req_header/2`.
  `tolerance` is the allowed deviation in seconds from the current system time
  to the expiration timestamp found in the `signature` token. Defaults to 30
  seconds.
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
      {:ok, _} ->
        {:ok, convert_to_event!(payload)}

      error ->
        error
    end
  end

  defp verify_signature_header(payload, signature_header, tolerance) do
    case Joken.peek_header(signature_header) do
      {:ok, %{"alg" => alg, "kid" => kid}} ->
        case Key.find(kid) do
          {:ok, %Key{} = signer_key} ->
            signer = Joken.Signer.create(alg, signer_key_map(signer_key))
            Joken.verify_and_validate(
              token_config(),
              signature_header,
              signer,
              %{tolerance: tolerance, payload: payload}
            )

          {:ok, nil} ->
            {:error, "The key id from the header didn't match an available signing key"}

          {:error, _} ->
            {:error, "There was an error retrieving the webhook keys"}
        end

      _ ->
        {:error, "Key details could not be parsed from the signature header"}
    end
  end

  defp token_config do
    [
      iss: Ibanity.Configuration.api_url(),
      skip: [:aud]
    ]
    |> Joken.Config.default_claims()
    |> Joken.Config.add_claim("digest", nil, &validate_digest/3)
    |> Joken.Config.add_claim("exp", nil, &validate_expiration/3)
  end

  defp validate_digest(digest, _, %{payload: payload}),
    do: digest == Base.encode64(:crypto.hash(:sha512, payload), case: :lower)

  defp validate_expiration(exp, _, %{tolerance: tolerance}),
    do: exp >= (System.system_time(:second) - tolerance)

  defp signer_key_map(%Key{} = signer_key) do
    signer_key
    |> Map.from_struct()
    |> Enum.into(%{}, fn {key, value} -> {to_string(key), value} end)
  end

  defp convert_to_event!(payload) do
    %{"data" => %{"type" => type} = data} = Jason.decode!(payload)

    Ibanity.JsonDeserializer.deserialize(data, type)
  end
end
