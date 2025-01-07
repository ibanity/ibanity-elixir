import Config

config :ibanity, :applications, [
  default: []
]

config :ibanity, :api_url, "https://api.ibanity.com"
config :ibanity, :products, ["xs2a", "consent"]
