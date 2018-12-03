defmodule Ibanity.CryptoUtil do
  @moduledoc false

  @doc ~S"""
    iex> Ibanity.CryptoUtil.sha512sum("Foobar")
    "zq0fWamg0i5Goo-UOmYjON11jW3OOPfqarE7ZhXDEraf__8El4HBabWXV3y1Vm1dE1Q2SsAyqdTVvY74MzQAYQ=="
  """
  @spec sha512sum(binary()) :: String.t()
  def sha512sum(bin) do
    bin
    |> ExCrypto.Hash.sha512!()
    |> Base.url_encode64()
  end

  @doc ~S"""
    iex> Ibanity.CryptoUtil.sha256sum("Foobar")
    "6BGBj4DZw8ItV3uoPWGWeI5VO7QIU1u0IQXN_3JqYKs="
  """
  @spec sha256sum(binary()) :: String.t()
  def sha256sum(bin) do
    bin
    |> ExCrypto.Hash.sha256!()
    |> Base.url_encode64()
  end
end
