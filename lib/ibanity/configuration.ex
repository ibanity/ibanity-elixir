defmodule Ibanity.Configuration do
  @moduledoc false

  use Agent
  alias Ibanity.ApiSchema

  defstruct [
    api_schema: nil,
    api_url: nil,
    ssl_options: nil,
    signature_options: nil
  ]

  @default_api_url "https://api.ibanity.com"

  def start_link(environment) do
    Agent.start_link(fn -> init(environment) end, name: __MODULE__)
  end

  def ssl_options, do: Agent.get(__MODULE__, &(&1.ssl_options))
  def api_schema, do: Agent.get(__MODULE__, &(&1.api_schema))
  def signature_options, do: Agent.get(__MODULE__, &(&1.signature_options))

  defp init(environment) do
    config = %__MODULE__{
      api_url: Keyword.get(environment, :api_url, @default_api_url),
      ssl_options: ssl_options(environment),
      signature_options: signature_options(environment)
    }

    %{config | api_schema: ApiSchema.fetch(config, Mix.env)}
  end

  defp signature_options(environment) do
    if Keyword.get(environment, :signature_certificate_file) &&
        Keyword.get(environment, :signature_certificate_id) &&
        Keyword.get(environment, :signature_key_file) do
      [
        certificate:    environment |> Keyword.get(:signature_certificate_file) |> File.read!,
        certificate_id: environment |> Keyword.get(:signature_certificate_id),
        signature_key:  environment |> Keyword.get(:signature_key_file) |> ExPublicKey.load!
      ]
    end
  end

  defp ssl_options(environment) do
    []
    |> add_certificate_file(environment)
    |> add_key_file(environment)
    |> add_ca_cert_file(environment)
  end

  defp add_ca_cert_file(ssl_options, environment) do
    ca_cert_file = Keyword.get(environment, :ssl_ca_file)
    if ca_cert_file, do: Keyword.put_new(ssl_options, :cacertfile, ca_cert_file), else: ssl_options
  end

  defp add_certificate_file(ssl_options, environment) do
    cert_file = Keyword.get(environment, :certificate_file)
    if cert_file, do: Keyword.put_new(ssl_options, :certfile, cert_file), else: ssl_options
  end

  defp add_certificate(ssl_options, environment) do
    cert = Keyword.get(environment, :certificate)
    if cert, do: Keyword.put_new(ssl_options, :cert, cert), else: ssl_options
  end

  defp add_key(ssl_options, environment) do
    key = Keyword.get(environment, :key)
    if key, do: Keyword.put_new(ssl_options, :key, {:RSAPrivateKey, key}), else: ssl_options
  end

  defp add_key_file(ssl_options, environment) do
    key_file = Keyword.get(environment, :key_file)
    if key_file, do: Keyword.put_new(ssl_options, :keyfile, key_file), else: ssl_options
  end
end
