defmodule Ibanity.CryptoUtil do
  @moduledoc false
  alias Ibanity.CryptoUtil.{PrivateKey, PublicKey}

  @doc ~S"""
    iex> Ibanity.CryptoUtil.sha512sum("Foobar")
    "zq0fWamg0i5Goo-UOmYjON11jW3OOPfqarE7ZhXDEraf__8El4HBabWXV3y1Vm1dE1Q2SsAyqdTVvY74MzQAYQ=="
  """
  @spec sha512sum(binary()) :: String.t()
  def sha512sum(bin) do
    :sha512
    |> :crypto.hash(bin)
    |> Base.url_encode64()
  end

  @doc ~S"""
    iex> Ibanity.CryptoUtil.sha256sum("Foobar")
    "6BGBj4DZw8ItV3uoPWGWeI5VO7QIU1u0IQXN_3JqYKs="
  """
  @spec sha256sum(binary()) :: String.t()
  def sha256sum(bin) do
    :sha256
    |> :crypto.hash(bin)
    |> Base.url_encode64()
  end

  @doc """
  Converts a PEM string into an `%Ibanity.CryptoUtil.PrivateKey{}` or an `%Ibanity.CryptoUtil.PublicKey{}` struct.
  Optionally, a passphrase can be given to decode the PEM certificate.

  ## Examples
      key = Ibanity.CryptoUtil.loads!(pem_string)

      key = Ibanity.CryptoUtil.loads!(pem_string, "pem_password")

  """
  def loads!(pem_string, passphrase \\ nil) do
    pem_entries = :public_key.pem_decode(pem_string)

    with {:ok, pem_entry} <- validate_pem_length(pem_entries),
         {:ok, rsa_key} <- load_pem_entry(pem_entry, passphrase),
         do: sort_key_tup(rsa_key)
  end

  def private_key_from_sequence(private_key), do: PrivateKey.from_sequence(private_key)

  defp sort_key_tup(key_tup) do
    case elem(key_tup, 0) do
      :RSAPrivateKey ->
        PrivateKey.from_sequence(key_tup)

      :RSAPublicKey ->
        PublicKey.from_sequence(key_tup)

      x ->
        {:error,
         "invalid argument, expected one of[Ibanity.CryptoUtil.PublicKey, Ibanity.CryptoUtil.PrivateKey], found: #{inspect(x)}"}
    end
  end

  defp validate_pem_length(pem_entries) do
    case length(pem_entries) do
      0 -> {:error, "invalid argument"}
      1 -> {:ok, Enum.at(pem_entries, 0)}
      _ -> {:error, "found multiple PEM entries, expected only 1"}
    end
  end

  defp load_pem_entry(pem_entry, passphrase) when is_binary(passphrase),
    do: load_pem_entry(pem_entry, String.to_charlist(passphrase))

  defp load_pem_entry(pem_entry, passphrase) do
    if passphrase == nil do
      {:ok, :public_key.pem_entry_decode(pem_entry)}
    else
      {:ok, :public_key.pem_entry_decode(pem_entry, passphrase)}
    end
  end
end
