# Ibanity Elixir Library

The Ibanity Elixir Library provides convenient wrappers around the Ibanity API. The object attributes are dynamically defined based on the API response, supporting minor API changes seamlessly.

## Documentation

Visit our [API docs](https://documentation.ibanity.com/api).

## Installation

In the `mix.exs` file:
```elixir
def deps do
  [{:ibanity, github: "ibanity/ibanity-elixir"}]
end
```

## Configuration

### Signature

When making HTTP requests for _live_ applications, each request *must* be signed, see [API reference](https://documentation.ibanity.com/api#signature). Therefore the `:signature_certificate_file`, `:signature_key_file` and `signature_certificate_id` keys must be set. *Please note that, at this time, Ibanity use the same certificate for both identifying and signing the requests, but it will change in a near future.*

### Required

Key | Description
--- | -----------
`:certificate_file` | Path to the certificate used to identify your API client
`:key_file` | Path to the private key used to generate the identifying certificate. *Note: the key should be in clear text*
`:signature_certificate_file` | Path to the certificate used to sign HTTP requests to the API
`:signature_key_file` | Path to the private key used to generate the signing certificate. *Note: the key should be in clear text*
`:signature_certificate_id` | ID (UUIDv4) of the certificate used for signature

### Optional

Key | Description
--- | -----------
`:api_url` | Ibanity API endpoint. Default: `https://api.ibanity.com`
`:ssl_ca_file` | Path to the intermediate certificate file. Not needed in _production_ environment

### Example

```elixir
config :ibanity, :certificate_file, System.get_env("IBANITY_CERTIFICATE")
config :ibanity, :key_file, System.get_env("IBANITY_KEY")
config :ibanity, :signature_certificate_file, System.get_env("IBANITY_CERTIFICATE")
config :ibanity, :signature_key_file, System.get_env("IBANITY_KEY")
config :ibanity, :signature_certificate_id, System.get_env("IBANITY_CERTIFICATE_ID")
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

#### Update an existing financial institution

```elixir
[name: "WowBank"]
|> Request.attributes
|> Request.idempotency_key("d49e91fb-58c4-4953-a4c3-71365139316d")
|> Request.ids(id: "0864492c-dbf4-43bd-8764-e0b52f4136d4")
|> FinancialInstitution.update
```
