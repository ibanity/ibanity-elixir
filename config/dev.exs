use Mix.Config

config :ibanity, :certificate_file, System.get_env("IBANITY_CERTIFICATE")
config :ibanity, :key_file, System.get_env("IBANITY_KEY")
config :ibanity, :signature_certificate_file, System.get_env("IBANITY_CERTIFICATE")
config :ibanity, :signature_certificate_id, System.get_env("IBANITY_CERTIFICATE_ID")
config :ibanity, :signature_key_file, System.get_env("IBANITY_KEY")
config :ibanity, :api_url, System.get_env("IBANITY_API_URL")
config :ibanity, :ssl_ca_file, System.get_env("IBANITY_CA_FILE")
