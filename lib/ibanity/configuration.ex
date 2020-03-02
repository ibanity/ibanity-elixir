defmodule Ibanity.Configuration do
  @moduledoc false

  use Agent
  use Retry
  alias Ibanity.{ApiSchema, Configuration.Options}
  alias Ibanity.Configuration.Exception, as: ConfigurationException

  defstruct api_schema: %{},
            applications_options: [],
            retry_options: [],
            timeout_options: []

  defmodule Exception do
    @moduledoc false
    defexception message: nil
  end

  defmodule Options do
    @moduledoc false
    defstruct ssl: nil, signature: nil

    def ssl(%__MODULE__{} = opts), do: opts.ssl
    def signature(%__MODULE__{} = opts), do: opts.signature
  end

  @default_api_url "https://api.ibanity.com"
  @default_retry_options [initial_delay: 1000, backoff_interval: 500, max_retries: 0]
  @default_timeout_options [timeout: 8000, recv_timeout: 5000]

  def start_link(environment) do
    Agent.start_link(fn -> init(environment) end, name: __MODULE__)
  end

  def api_schema(product) do
    Map.get(Agent.get(__MODULE__, & &1.api_schema), product) || fetch_and_store_api_schema(product)
  end

  def fetch_and_store_api_schema(product) do
    schema = fetch_api_schema(product)
    Agent.get_and_update(__MODULE__, fn configuration ->
      merged_schema = Map.merge(configuration.api_schema, %{product => schema})
      {schema, %__MODULE__{configuration | api_schema: merged_schema}}
    end)
  end

  def fetch_api_schema("sandbox") do
    "xs2a"
    |> fetch_api_schema()
    |> Map.fetch!("sandbox")
  end
  def fetch_api_schema(product) do
    :ibanity
    |> Application.get_env(:api_url, @default_api_url)
    |> URI.parse()
    |> URI.merge("/#{product}")
    |> to_string()
    |> ApiSchema.fetch(default_app_options(), Mix.env())
  end

  def default_app_options, do: Agent.get(__MODULE__, & &1.applications_options[:default])

  def retry_options, do: Agent.get(__MODULE__, & &1.retry_options)

  def retry_backoff do
    retry_options()[:initial_delay]
    |> linear_backoff(retry_options()[:backoff_interval])
    |> Stream.take(retry_options()[:max_retries])
  end

  def timeout_options, do: Agent.get(__MODULE__, & &1.timeout_options)

  def ssl_options(app_name \\ :default) do
    app_name |> get_applications_options |> Options.ssl()
  end

  def signature_options(app_name \\ :default) do
    app_name |> get_applications_options |> Options.signature()
  end

  defp init(environment) do
    %__MODULE__{
      applications_options: extract_applications_options(environment),
      retry_options: extract_retry_options(environment),
      timeout_options: extract_timeout_options(environment)
    }
  end

  defp extract_retry_options(environment) do
    retry_options = environment |> Keyword.get(:retry, []) |> Keyword.take([:initial_delay, :backoff_interval, :max_retries])
    @default_retry_options |> Keyword.merge(retry_options)
  end

  defp extract_timeout_options(environment) do
    timeout_options = environment |> Keyword.get(:timeout, []) |> Keyword.take([:timeout, :recv_timeout])
    @default_timeout_options |> Keyword.merge(timeout_options)
  end

  defp extract_applications_options(environment) do
    applications_options =
      environment
      |> Keyword.fetch!(:applications)
      |> Enum.map(fn {app, conf} ->
        app_config = %Options{
          ssl: conf |> extract_ssl_options |> add_ca_cert(environment),
          signature: conf |> extract_signature_options
        }

        {app, app_config}
      end)

    if Keyword.has_key?(applications_options, :default) do
      applications_options
    else
      raise ConfigurationException, "No default application found"
    end
  end

  defp extract_signature_options(environment) do
    if Keyword.get(environment, :signature_certificate) &&
         Keyword.get(environment, :signature_certificate_id) &&
         Keyword.get(environment, :signature_key) do
      passphrase = Keyword.get(environment, :signature_key_passphrase)

      [
        certificate:
          environment |> Keyword.get(:signature_certificate),
        certificate_id:
          environment |> Keyword.get(:signature_certificate_id),
        signature_key:
          environment |> Keyword.get(:signature_key) |> ExPublicKey.loads!(passphrase)
      ]
    end
  end

  defp extract_ssl_options(environment) do
    []
    |> add_certificate(environment)
    |> add_key(environment)
  end

  defp add_ca_cert(ssl_options, environment) do
    case Keyword.get(environment, :ssl_ca) do
      nil ->
        ssl_options

      cert ->
        Keyword.put_new(ssl_options, :cacerts, [der_encoded_certificate(cert)])
    end
  end

  defp add_certificate(ssl_options, environment) do
    case Keyword.get(environment, :certificate) do
      nil ->
        ssl_options

      cert ->
        Keyword.put_new(ssl_options, :cert, der_encoded_certificate(cert))
    end
  end

  defp add_key(ssl_options, environment) do
    case Keyword.get(environment, :key) do
      nil ->
        ssl_options

      key ->
        passphrase = Keyword.get(environment, :key_passphrase)
        Keyword.put_new(ssl_options, :key, get_key_der(key, passphrase))
    end
  end

  defp get_applications_options(app_name) do
    config = Agent.get(__MODULE__, & &1)

    case Keyword.fetch(config.applications_options, app_name) do
      {:ok, applications_options} -> applications_options
      :error -> raise ConfigurationException, "No application named '#{app_name}' has been found"
    end
  end

  defp der_encoded_certificate(pem_certificate) do
    {:Certificate, cert, :not_encrypted} =
      pem_certificate
      |> :public_key.pem_decode()
      |> List.first()

    cert
  end


  # See https://elixirforum.com/t/using-client-certificates-from-a-string-with-httposion/8631/7
  defp split_type_and_entry(asn1_entry) do
    asn1_type = asn1_entry |> elem(0)
    {asn1_type, asn1_entry}
  end

  defp decode_pem_bin(pem_bin) do
    pem_bin |> :public_key.pem_decode() |> hd()
  end

  defp decode_pem_entry(pem_entry, password) do
    password = String.to_charlist(password)
    :public_key.pem_entry_decode(pem_entry, password)
  end

  defp encode_der(ans1_type, ans1_entity) do
    :public_key.der_encode(ans1_type, ans1_entity)
  end

  defp get_key_der(priv_key_pem, nil) do
    {type, encoded, _atom} = decode_pem_bin(priv_key_pem)
    {type, encoded}
  end
  defp get_key_der(priv_key_pem, password) do
    {key_type, key_entry} =
      priv_key_pem
      |> decode_pem_bin()
      |> decode_pem_entry(password)
      |> split_type_and_entry()

    {key_type, encode_der(key_type, key_entry)}
  end
end
