import Config

config :ibanity, :applications,
  default: [
    certificate: System.get_env("IBANITY_CERTIFICATE"),
    key: System.get_env("IBANITY_KEY"),
    key_passphrase: System.get_env("IBANITY_KEY_PASSPHRASE"),
    signature_certificate: System.get_env("IBANITY_CERTIFICATE"),
    signature_certificate_id: System.get_env("IBANITY_CERTIFICATE_ID"),
    signature_key: System.get_env("IBANITY_KEY"),
    signature_key_passphrase: System.get_env("IBANITY_KEY_PASSPHRASE")
  ]

config :ibanity, :api_url, System.get_env("IBANITY_API_URL")
config :ibanity, :ssl_ca, System.get_env("IBANITY_CA")
