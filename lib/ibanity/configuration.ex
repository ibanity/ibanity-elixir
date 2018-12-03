defmodule Ibanity.Configuration do
  @moduledoc false

  use Agent
  alias Ibanity.{ApiSchema, Configuration.Options}
  alias Ibanity.Configuration.Exception, as: ConfigurationException

  defstruct api_schema: nil,
            applications_options: []

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

  def start_link(environment) do
    Agent.start_link(fn -> init(environment) end, name: __MODULE__)
  end

  def api_schema, do: Agent.get(__MODULE__, & &1.api_schema)

  def ssl_options(app_name \\ :default) do
    app_name |> get_applications_options |> Options.ssl()
  end

  def signature_options(app_name \\ :default) do
    app_name |> get_applications_options |> Options.signature()
  end

  defp init(environment) do
    api_url = Keyword.get(environment, :api_url, @default_api_url)
    applications_options = extract_applications_options(environment)
    default_app_options = Keyword.fetch!(applications_options, :default)

    %__MODULE__{
      api_schema: ApiSchema.fetch(api_url, default_app_options.ssl, Mix.env()),
      applications_options: applications_options
    }
  end

  defp extract_applications_options(environment) do
    applications_options =
      environment
      |> Keyword.fetch!(:applications)
      |> Enum.map(fn {app, conf} ->
        app_config = %Options{
          ssl: conf |> extract_ssl_options |> add_ca_cert_file(environment),
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
    if Keyword.get(environment, :signature_certificate_file) &&
         Keyword.get(environment, :signature_certificate_id) &&
         Keyword.get(environment, :signature_key_file) do
      [
        certificate: environment |> Keyword.get(:signature_certificate_file) |> File.read!(),
        certificate_id: environment |> Keyword.get(:signature_certificate_id),
        signature_key: environment |> Keyword.get(:signature_key_file) |> ExPublicKey.load!()
      ]
    end
  end

  defp extract_ssl_options(environment) do
    []
    |> add_certificate_file(environment)
    |> add_key_file(environment)
  end

  defp add_ca_cert_file(ssl_options, environment) do
    ca_cert_file = Keyword.get(environment, :ssl_ca_file)

    if ca_cert_file,
      do: Keyword.put_new(ssl_options, :cacertfile, ca_cert_file),
      else: ssl_options
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

  defp get_applications_options(app_name) do
    config = Agent.get(__MODULE__, & &1)

    case Keyword.fetch(config.applications_options, app_name) do
      {:ok, applications_options} -> applications_options
      :error -> raise ConfigurationException, "No application named '#{app_name}' has been found"
    end
  end
end
