use Mix.Config

config :ibanity, :applications, [
  default: []
]

config :ibanity, :api_url, System.get_env("IBANITY_API_URL")
