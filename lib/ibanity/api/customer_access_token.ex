defmodule Ibanity.CustomerAccessToken do
  alias Ibanity.{Client, Collection, Configuration, CustomerAccessToken, Request, ResourceOperations}

  @base_keys [:token]
  @enforce_keys [:id | @base_keys]
  defstruct id: nil, token: nil

  def create(application_customer_reference, idempotency_key \\ nil) do
    uri = Map.get(Configuration.api_schema(), "customerAccessTokens")

    request =
      uri
      |> Request.new
      |> Request.resource_type("customerAccessToken")
      |> Request.idempotency_key(idempotency_key)
      |> Request.attributes(%{application_customer_reference: application_customer_reference})
      |> Request.build

    ResourceOperations.create_by_uri(__MODULE__, request)
  end

  def keys, do: @base_keys
end