use Mix.Config

config :ibanity, :certificate, "/Users/bruno/devel/credentials/certificate.pem"
config :ibanity, :key, "/Users/bruno/devel/credentials/newkey.pem"
config :ibanity, :api_url, "https://api.ibanity.localhost:443"
config :ibanity, :ssl_ca_file, "/Users/bruno/devel/ibanity/credentials/certificates/root_ca.cert.pem"