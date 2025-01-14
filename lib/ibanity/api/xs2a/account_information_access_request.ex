defmodule Ibanity.Xs2a.AccountInformationAccessRequest do
  @moduledoc """
  [Account information access requests](https://documentation.ibanity.com/xs2a/api#account-information-access-request) API wrapper
  """

  use Ibanity.Resource

  defstruct id: nil,
            redirect_link: nil,
            requested_account_references: nil,
            status: nil,
            errors: nil,
            skip_ibanity_completion_callback: false,
            allow_financial_institution_redirect_uri: false

  @api_schema_path [
    "xs2a",
    "customer",
    "financialInstitution",
    "accountInformationAccessRequests"
  ]

  @doc """
  [Creates an account information access request](https://documentation.ibanity.com/xs2a/api#create-account-information-access-request)

  In order for the request to be successful you must have created a `Ibanity.Xs2a.CustomerAccessToken` beforehand.

  ## Example

  This is the transcription of the example found in the [API documentation](https://documentation.ibanity.com/xs2a/api#create-account-information-access-request)

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
    |> Request.id(:id, "")
    |> Client.execute(:post, @api_schema_path)
  end

  @doc """
  [Retrieves an account information access request](https://documentation.ibanity.com/xs2a/api#get-account-information-access-request)

  ## Example

  This is the transcription of the example found in the [API documentation](https://documentation.ibanity.com/xs2a/api#get-account-information-access-request)

      iex> "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9..."
      ...> |> Request.customer_access_token
      ...> |> Request.ids(financial_institution_id: "b031dfe8-ebad-410b-aa77-064f8c876540", id: "42ebed1a-d890-41d6-b4f2-ac1ef6fd0e32")
      ...> |> AccountInformationAccessRequest.find
      {:ok,
        %Ibanity.AccountInformationAccessRequest{
          id: "fff0f73b-cc51-4a18-8f11-1a8434e66b49",
          requested_account_references: []
        }
      }
  """
  def find(%Request{} = request) do
    request
    |> Client.execute(:get, @api_schema_path)
  end

  @doc false
  def key_mapping do
    [
      id: {~w(id), :string},
      redirect_link: {~w(links redirect), :string},
      requested_account_references: {~w(attributes requestedAccountReferences), :string},
      status: {~w(attributes status), :string},
      errors: {~w(attributes errors), :string},
      skip_ibanity_completion_callback: {~w(attributes skipIbanityCompletionCallback), :boolean},
      allow_financial_institution_redirect_uri:
        {~w(attributes allowFinancialInstitutionRedirectUri), :boolean}
    ]
  end
end
