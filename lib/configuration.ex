defmodule Ibanity.Configuration do
  defstruct [
    :certificate,
    :key,
    :key_passphrase,
    :signature_certificate,
    :signature_certificate_id,
    :signature_key,
    :signature_key_passphrase,
    :api_scheme,
    :api_host,
    :api_port,
    :ssl_ca_file
  ]
end