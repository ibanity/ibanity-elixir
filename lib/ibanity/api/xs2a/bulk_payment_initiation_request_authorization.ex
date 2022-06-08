defmodule Ibanity.Xs2a.BulkPaymentInitiationRequestAuthorization do
  @moduledoc """
  [Payment initiation requests](https://documentation.ibanity.com/xs2a/api#bulk-payment-initiation-request-authorization) API wrapper
  """

  use Ibanity.Resource

  defstruct id: nil,
            status: nil

  @api_schema_path ["xs2a", "customer", "financialInstitution", "bulkPaymentInitiationRequest", "authorizations"]

  @doc """
  [Creates an account information access request authorization](https://documentation.ibanity.com/xs2a/api#create-bulk-payment-initiation-request-authorization)

  In order for the request to be successful you must have created a `Ibanity.Xs2a.CustomerAccessToken` beforehand.

  ## Example

  This is the transcription of the example found in the [API documentation](https://documentation.ibanity.com/xs2a/api#create-bulk-payment-initiation-request-authorization)

      iex> "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9..."
      ...> |> Request.customer_access_token
      ...> |> Request.id(:financial_institution_id, "b031dfe8-ebad-410b-aa77-064f8c876540")
      ...> |> Request.id(:payment_initiation_request_id, "b031dfe8-ebad-410b-aa77-064f8c876540")
      ...> |> Request.attribute("query_parameters", %{})
      ...> |> BulkPaymentInitiationRequestAuthorization.create
      {:ok,
        %Ibanity.Xs2a.BulkPaymentInitiationRequestAuthorization{
          id: "ce410d99-6382-4463-bfd6-fa606c379dea",
          status: nil
        }
      }

  """
  def create(%Request{} = request) do
    request
    |> Request.resource_type("bulk_payment_initiation_request_authorization")
    |> Request.id(:id, "")
    |> Client.execute(:post, @api_schema_path, "bulkPaymentInitiationRequestAuthorization")
  end


  @doc false
  def key_mapping do
    [
      id: {~w(id), :string},
      status: {~w(attributes status), :string}
    ]
  end
end
