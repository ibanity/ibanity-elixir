defmodule Ibanity.CryptoUtil.PublicKey do
  @moduledoc false

  defstruct version: nil,
            public_modulus: nil,
            public_exponent: nil

  @type t :: %__MODULE__{
          version: atom,
          public_modulus: integer,
          public_exponent: integer
        }

  def from_sequence(rsa_key_seq) do
    %__MODULE__{}
    |> struct(
      public_modulus: elem(rsa_key_seq, 1),
      public_exponent: elem(rsa_key_seq, 2)
    )
  end

  def as_sequence(rsa_public_key) do
    case rsa_public_key do
      %__MODULE__{} ->
        {:ok,
         {
           :RSAPublicKey,
           Map.get(rsa_public_key, :public_modulus),
           Map.get(rsa_public_key, :public_exponent)
         }}

      _ ->
        {:error, "invalid public key: #{rsa_public_key}"}
    end
  end

  def get_fingerprint(%__MODULE__{} = rsa_public_key, opts \\ []) do
    digest_type = Keyword.get(opts, :digest_type, :sha256)
    colons = Keyword.get(opts, :colons, false)

    {:ok, der_encoded} = encode_der(rsa_public_key)
    digest = :crypto.hash(digest_type, der_encoded)
    hex_fp = Base.encode16(digest, case: :lower)
    add_fingerprint_colons(hex_fp, colons)
  end

  def encode_der(%__MODULE__{} = rsa_public_key) do
    with {:ok, key_sequence} <- as_sequence(rsa_public_key) do
      pem_entry = :public_key.pem_entry_encode(:SubjectPublicKeyInfo, key_sequence)

      der_encoded =
        :public_key.pem_encode([pem_entry])
        |> String.trim()
        |> String.split("\n")
        |> Enum.filter(fn line -> !String.contains?(line, "-----") end)
        |> Enum.join("")
        |> Base.decode64!()

      {:ok, der_encoded}
    end
  end

  def decode_der(der_encoded, opts \\ []) do
    # also supports :RSAPublicKey
    format = Keyword.get(opts, :format, :SubjectPublicKeyInfo)

    :public_key.der_decode(format, der_encoded)
    |> from_der_encoded_0()
  end

  # Protocols

  defimpl Inspect do
    import Inspect.Algebra
    alias Ibanity.CryptoUtil.PublicKey

    @doc """
    Formats the RSAPrivateKey and includes the SHA256 fingerprint.

    example:
    ```
    #Ibanity.CryptoUtil.PublicKey<
     fingerprint_sha256=7a:40:1c:b9:4b:b8:a5:bb:6b:98:b6:1b:8b:7a:24:8d:45:9b:e5:54
      17:7e:66:26:7e:95:11:9d:39:14:7b:b2>
    ```
    """
    def inspect(data, _opts) do
      fp_opts = [digest_type: :sha256, colons: true]

      fp_sha256_parts_doc =
        PublicKey.get_fingerprint(data, fp_opts)
        |> String.split(":")
        |> fold_doc(fn doc, acc -> glue(doc, ":", acc) end)

      fp_sha256_doc =
        glue("fingerprint_sha256=", "", fp_sha256_parts_doc)
        |> group()
        |> nest(2)

      glue("#Ibanity.CryptoUtil.PublicKey<", "", fp_sha256_doc)
      |> concat(">")
      |> nest(2)
    end
  end

  # Helpers

  defp add_fingerprint_colons(data, true) do
    case String.valid?(data) do
      true ->
        String.splitter(data, "", trim: true)
        |> Enum.chunk_every(2)
        |> Enum.map_join(":", &Enum.join/1)

      false ->
        data
    end
  end

  defp add_fingerprint_colons(data, _false) do
    data
  end

  def from_der_encoded_0({:SubjectPublicKeyInfo, _, der_key}) do
    with {:RSAPublicKey, pub_mod, pub_exp} <- :public_key.der_decode(:RSAPublicKey, der_key),
         do: from_der_encoded_0({:RSAPublicKey, pub_mod, pub_exp})
  end

  def from_der_encoded_0({:RSAPublicKey, pub_mod, pub_exp}) do
    rsa_pub_key = from_sequence({:RSAPublicKey, pub_mod, pub_exp})
    {:ok, rsa_pub_key}
  end

  def from_der_encoded_0(_other) do
    {:error, :invalid_public_key}
  end
end
