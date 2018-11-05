use Mix.Config

config :ibanity, :certificate, System.get_env("IBANITY_CERTIFICATE")
config :ibanity, :key, System.get_env("IBANITY_KEY")
config :ibanity, :api_url, System.get_env("IBANITY_API_URL")
config :ibanity, :ssl_ca_file, System.get_env("IBANITY_CA_FILE")
