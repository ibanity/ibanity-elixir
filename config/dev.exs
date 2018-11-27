use Mix.Config

config :ibanity, :applications, [
  default: [
    certificate_file: System.get_env("IBANITY_CERTIFICATE"),
    key_file: System.get_env("IBANITY_KEY"),
    signature_certificate_file: System.get_env("IBANITY_CERTIFICATE"),
    signature_certificate_id: System.get_env("IBANITY_CERTIFICATE_ID"),
    signature_key_file: System.get_env("IBANITY_KEY")
  ]
]

config :ibanity, :api_url, System.get_env("IBANITY_API_URL")
config :ibanity, :ssl_ca_file, System.get_env("IBANITY_CA_FILE")
