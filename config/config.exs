# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
import Config

config :ibanity, env: config_env()

import_config "#{config_env()}.exs"
