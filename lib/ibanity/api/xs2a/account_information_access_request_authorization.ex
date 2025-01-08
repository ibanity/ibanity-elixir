defmodule Ibanity.Xs2a.AccountInformationAccessRequestAuthorization do
  @moduledoc """
  [Account information access requests](https://documentation.ibanity.com/xs2a/api#account-information-access-request-authorization) API wrapper
  """

  use Ibanity.Resource

  defstruct id: nil,
            status: nil

  @api_schema_path [
    "xs2a",
    "customer",
    "financialInstitution",
    "accountInformationAccessRequest",
    "authorizations"
  ]

  @doc """
  [Creates an account information access request authorization](https://documentation.ibanity.com/xs2a/api#create-account-information-access-request-authorization)

  In order for the request to be successful you must have created a `Ibanity.Xs2a.CustomerAccessToken` beforehand.

  ## Example

  This is the transcription of the example found in the [API documentation](https://documentation.ibanity.com/xs2a/api#create-account-information-access-request-authorization)

      iex> "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9..."
      ...> |> Request.customer_access_token
      ...> |> Request.id(:financial_institution_id, "b031dfe8-ebad-410b-aa77-064f8c876540")
      ...> |> Request.id(:account_information_access_request_id, "b031dfe8-ebad-410b-aa77-064f8c876540")
      ...> |> Request.attribute("query_parameters", %{code: "SFMyNTY.g3QAAAA..."})
      ...> |> AccountInformationAccessRequestAuthorization.create
      {:ok,
        %Ibanity.Xs2a.AccountInformationAccessRequestAuthorization{
          id: "3ffd82c0-944a-4cee-bf31-192e3137c76e",
          status: "succeeded"
        }
      }

  """
  def create(%Request{} = request) do
    request
    |> Request.resource_type("account_information_access_request_authorization")
    |> Request.id(:id, "")
    |> Client.execute(:post, @api_schema_path, "accountInformationAccessRequestAuthorization")
  end

  @doc false
  def key_mapping do
    [
      id: {~w(id), :string},
      status: {~w(attributes status), :string}
    ]
  end
end
