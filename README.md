# Ibanity Elixir Library

The Ibanity Elixir Library provides convenient wrappers around the Ibanity API. The object attributes are dynamically defined based on the API response, supporting minor API changes seamlessly.

## Documentation

Visit our [Elixir API docs](https://documentation.ibanity.com/api/elixir).

## Installation

```
def deps do
  [{:ibanity, "~> 0.1"}]
end
```

Be sure you have these environment variables set before using the library:
* `IBANITY_CERTIFICATE`: the path to the file containing the certificate, in PEM format, to authenticate against
* `IBANITY_KEY`: the path to the file containing the private key. *Note*: as of now it should be in a *uncrypted* PEM file
* `IBANITY_API_URL`: the URL of the Ibanity API, to which the client will connect.

The `IBANITY_CA_FILE` is optional and used only for development and test purposes. It is not used in production environment.

### Requirements

* Elixir 1.6+.
