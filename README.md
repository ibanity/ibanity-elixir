![Build Status](https://github.com/ibanity/ibanity-elixir/workflows/CI/badge.svg?branch=master)

# Ibanity Elixir Library

The Ibanity Elixir Library provides convenient wrappers around the Ibanity API. The object attributes are dynamically defined based on the API response, supporting minor API changes seamlessly.

## Documentation

Visit our [API docs](https://documentation.ibanity.com/api).

## Installation

In the `mix.exs` file:
```elixir
def deps do
  [{:ibanity, "~> 0.5.0}]
end
```

## Configuration

The client supports multiple _applications_, that is multiple configurations.
The reason for this is to enable, for example, _sandbox_ or _live_ environment, each having its own
configurations options (certificate, private key, ...).

There *must* be at least the `:default` application in your configuration file.

### Signature

When making HTTP requests for _live_ applications, each request *must* be signed, see [API reference](https://documentation.ibanity.com/api#signature). Therefore the `:signature_certificate_file`, `:signature_key_file` and `signature_certificate_id` keys must be set. *Please note that, at this time, Ibanity use the same certificate for both identifying and signing the requests, but it will change in a near future.*

### Per-application configuration

#### A note on certificates and private keys

Since Erlang (and thus Elixir) doesn't support PKCS12 at this time, you will have to use both certificate and private key in [PEM format](https://en.wikipedia.org/wiki/Privacy-Enhanced_Mail).
Moreover, Erlang doesn't support [AES-256-CBC](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard) either, you will thus have to encrypt the private key with `AES-128-CBC`.

If you use Ibanity's `sandbox` environment, you should have received three generated files: `certificate.pem`, `certificate.pfx`, `private_key.pem`.
Only the `.pem` files will be used by this client.

You will have to re-encrypt the private key. One way to do it is:
```
openssl rsa -aes128 -in private_key.pem -out private_key-aes128.pem
```

Key | Description
--- | -----------
`:certificate` | Certificate used to identify your API client.
`:key` | Private key used to generate the identifying certificate.
`:key_passphrase` | Password used to encrypt `:key`.
`:signature_certificate` | Certificate used to sign HTTP requests to the API.
`:signature_key` | Private key used to generate the signing certificate.
`:signature_key_passphrase` | Password used to encrypt `:signature_key`.
`:signature_certificate_id` | ID (UUIDv4) of the certificate used for signature.

### Global optional configuration

Key | Description
--- | -----------
`:api_url` | Ibanity API endpoint. Default: `https://api.ibanity.com`
`:ssl_ca` | Intermediate certificate. Not needed in _production_ environment
`:retry` | Keyword list to customize the retrying of API calls due to network failures. Keys and their default values are shown below.
`:timeout` | Keyword list to customize the timeout limits of API calls. Keys and their default values are shown below.
```elixir
  config :ibanity, :retry, [
    initial_delay: 1000,
    backoff_interval: 500,
    max_retries: 0
  ]
```
```elixir
  config :ibanity, :timeout, [
    timeout: 8000,
    recv_timeout: 5000
  ]
```

### Example

The minimal configuration must be:
```elixir
config :ibanity, :applications, [
  default: []
]

config :ibanity, :api_url, System.get_env("IBANITY_API_URL")
```
With that kind of configuration, requests won't use SSL nor HTTP signature.

Here's a full-fledged example with two applications, the `:default` one and `:sandbox`:
```elixir
config :ibanity, :applications, [
  default: [
    certificate: System.get_env("DEFAULT_CERTIFICATE"),
    key: System.get_env("DEFAULT_KEY"),
    signature_certificate: System.get_env("DEFAULT_CERTIFICATE"),
    signature_certificate_id: System.get_env("DEFAULT_CERTIFICATE_ID"),
    signature_key: System.get_env("DEFAULT_KEY")
  ],
  sandbox: [
    certificate: System.get_env("SANDBOX_CERTIFICATE"),
    key: System.get_env("SANDBOX_KEY"),
    signature_certificate: System.get_env("SANDBOX_CERTIFICATE"),
    signature_certificate_id: System.get_env("SANDBOX_CERTIFICATE_ID"),
    signature_key: System.get_env("SANDBOX_KEY")
  ]
]

config :ibanity, :api_url, System.get_env("IBANITY_API_URL")
config :ibanity, :ssl_ca, System.get_env("IBANITY_CA")
config :ibanity, :retry, [
  initial_delay: 1000,
  backoff_interval: 1000,
  max_retries: 3
]
config :ibanity, :timeout, [
  timeout: 10_000,
  recv_timeout: 30_000
]
```

### Requirements

* Elixir 1.6+.

## Test

`mix test`

## Usage

All operations take a `Ibanity.Request` structure as only parameter, though some convenience functions have been created in order to ease the use of the API.

For example, these:
```elixir
FinancialInstitution.find("3851df38-b78a-447a-910e-5c077f30798b")
```
```elixir
Request.id(:id, "3851df38-b78a-447a-910e-5c077f30798b")
|> FinancialInstitution.find
```
```elixir
[id: "3851df38-b78a-447a-910e-5c077f30798b"]
|> Request.ids
|> FinancialInstitution.find
```
are strictly equivalent

### A note on resource identifiers

In a RESTful API you sometimes have to provide multiple resource ids in the URL.
In order to pass them to the request you should use `Request.ids/2` to set them.
This function takes a `%Request{}` as first parameter and a Keyword list as second one where the keys are the name of the ids as defined in the documentation - but in _snake case_ - and the values are the matching UUIDs.
See examples below.

### Usage examples

#### Create a customer access token

```elixir
[application_customer_reference: "12345"]
|> Request.attributes
|> Request.idempotency_key("007572ed-77a9-4828-844c-1fc0180b9795")
|> CustomerAccessToken.create
```

#### List financial institutions with paging options

```elixir
Request.limit(1)
|> FinancialInstitutions.list
```

#### Update an existing financial institution using the _:sandbox_ application

```elixir
[name: "WowBank"]
|> Request.attributes
|> Request.idempotency_key("d49e91fb-58c4-4953-a4c3-71365139316d")
|> Request.ids(id: "0864492c-dbf4-43bd-8764-e0b52f4136d4")
|> Request.application(:sandbox)
|> FinancialInstitution.update
```
