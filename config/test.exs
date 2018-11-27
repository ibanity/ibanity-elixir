use Mix.Config

config :ibanity, :applications, [
  default: []
]

config :ibanity, :api_url, System.get_env("IBANITY_API_URL")
config :ibanity, :ssl_ca_file, System.get_env("IBANITY_CA_FILE")
