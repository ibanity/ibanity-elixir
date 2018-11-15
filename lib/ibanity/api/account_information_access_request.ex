defmodule Ibanity.AccountInformationAccessRequest do
  @moduledoc """
  [Account information access requests](https://documentation.ibanity.com/api#account-information-access-request) API wrapper
  """

  use Ibanity.Resource

  defstruct [
    id: nil,
    redirect_link: nil,
    requested_account_references: nil
  ]

  @api_schema_path  ["customer", "financialInstitution", "accountInformationAccessRequests"]

  @doc """
  [Creates an account information access request](https://documentation.ibanity.com/api#create-account-information-access-request)

  In order for the request to be successful you must have created a `Ibanity.CustomerAccessToken` beforehand.

  ## Example

  This is the transcription of the example found in the [API documentation](https://documentation.ibanity.com/api#create-account-information-access-request)

      iex> "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9..."
      ...> |> Request.customer_access_token
      ...> |> Request.id(:financial_institution_id, "b031dfe8-ebad-410b-aa77-064f8c876540")
      ...> |> Request.attribute("redirect_uri", "https://fake-tpp.com/access-granted")
      ...> |> Request.attribute("consent_reference", "42ebed1a-d890-41d6-b4f2-ac1ef6fd0e32")
      ...> |> Request.attribute("requested_account_references", ["BE6338957016536095"])
      ...> |> AccountInformationAccessRequest.create
      {:ok,
        %Ibanity.AccountInformationAccessRequest{
          id: "fff0f73b-cc51-4a18-8f11-1a8434e66b49",
          redirect_link: "https://callback.ibanity.localhost/sandbox/fi/aiar/i?state=dmF1bHQ6d...UcA==",
          requested_account_references: []
        }
      }

  *Note: it doesn't support the `meta` argument yet, it will be supported in a future release.*
  """
  def create(%Request{} = request) do
    request
    |> Request.resource_type("account_information_access_request")
    |> Client.execute(:post, @api_schema_path)
  end

  @doc false
  def key_mapping do
    [
      id: ~w(id),
      redirect_link: ~w(links redirect),
      requested_account_references: ~w(attributes requestedAccountReferences)
    ]
  end
end
