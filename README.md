# Ibanity Elixir Library

The Ibanity Elixir Library provides convenient wrappers around the Ibanity API. The object attributes are dynamically defined based on the API response, supporting minor API changes seamlessly.

## !!! Disclaimer !!!

This library is under **heavy** development and should be considered *alpha* state; its API is unstable and can be changed at any time without any notice.
It is therefore not yet ready for production !

## Documentation

Visit our [API docs](https://documentation.ibanity.com/api).

## Installation

In the `mix.exs` file:
```elixir
def deps do
  [{:ibanity, github: "ibanity/ibanity-elixir"}]
end
```

In your configuration:
```elixir
config :ibanity, :certificate, "path/to/your/certificate.pem"
config :ibanity, :key, "path/to/your/private/key.pem" # Note, at this moment it doesn't support encrypted key !
config :ibanity, :api_url, "https://api.development.ibanity.com" # Default is "https://api.ibanity.com"
config :ibanity, :ssl_ca_file, "path/to/ca_file.pem" # Optional, not needed in production
```

### Requirements

* Elixir 1.6+.

## Test

`mix test --no-start`

## Usage

All operations take a `Ibanity.Request` structure as only parameter, though some convenience functions have been created in order to ease the use of the API.

### A note on resource identifiers

In a RESTful API you sometimes have to provide multiple resource ids in the URL.
In order to pass them to the request you should use `Request.ids/2` to set them.
This function takes a `%Request{}` as first parameter and a Keyword list as second one where the keys are the name of the ids as defined in the documentation, and the values are the matching UUIDs.
See examples below.

### Usage examples

```
# Create an access token, use an optional idempotency key
[applicationCustomerReference: "12345"]
|> Request.attributes`
|> Request.idempotency_key("007572ed-77a9-4828-844c-1fc0180b9795")
|> CustomerAccessToken.create
# => %Ibanity.CustomerAccessToken{id: "b2d81d9a-1a10-4bb6-a354-9910b8b64a01", token: "eyJ0eXAiOiJKV1QiLCJhbGc..."}

# List financial institutions
FinancialInstitutions.list
# %Ibanity.Collection{
#   after_cursor: nil,
#   before_cursor: nil,
#   class: Ibanity.FinancialInstitution,
#   first_link: nil,
#   items: [
#     %Ibanity.FinancialInstitution{
#       id: "44d3be20-4423-475e-9433-8b5fe48e0c64",
#       name: "Acme Bank",
#       sandbox: false,
#       self_link: "https://api.ibanity.com/financial-institutions/44d3be20-4423-475e-9433-8b5fe48e0c64"
#     },
#     %Ibanity.FinancialInstitution{...}
#   ]
# }

# Update an existing financial institution
[name: "WowBank"]
|> Request.attributes
|> Request.ids(financialInstitutionId: "0864492c-dbf4-43bd-8764-e0b52f4136d4")
|> FinancialInstitution.update
# => %Ibanity.FinancialInstitution{id: "0864492c-dbf4-43bd-8764-e0b52f4136d4", name: "WowBank", ...}
```