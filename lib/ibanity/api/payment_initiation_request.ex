defmodule Ibanity.PaymentInitiationRequest do
  @moduledoc """
  [Payment initiation requests](https://documentation.ibanity.com/api#payment-initiation-request) API wrapper
  """

  use Ibanity.Resource

  @api_schema_path ~w(customer financialInstitution paymentInitiationRequests)
  @resource_type "payment_initiation_request"

  defstruct [
    id: nil,
    status: nil,
    remittance_information_type: nil,
    remittance_information: nil,
    product_type: nil,
    end_to_end_id: nil,
    debtor_name: nil,
    debtor_account_reference_type: nil,
    debtor_account_reference: nil,
    currency: nil,
    creditor_name: nil,
    creditor_agent_type: nil,
    creditor_agent: nil,
    creditor_account_reference_type: nil,
    creditor_account_reference: nil,
    consent_reference: nil,
    amount: nil,
    redirect_link: nil
  ]

  @doc false
  def key_mapping do
    [
      id: {~w(id), :string},
      status: {~w(attributes status), :string},
      remittance_information_type: {~w(attributes remittanceInformationType), :string},
      remittance_information: {~w(attributes remittanceInformation), :string},
      product_type: {~w(attributes productType), :string},
      end_to_end_id: {~w(attributes endToEndId), :string},
      debtor_name: {~w(attributes debtorName), :string},
      debtor_account_reference_type: {~w(attributes debtorAccountReferenceType), :string},
      debtor_account_reference: {~w(attributes debtorAccountReference), :string},
      currency: {~w(attributes currency), :string},
      creditor_name: {~w(attributes creditorName), :string},
      creditor_agent_type: {~w(attributes creditorAgentType), :string},
      creditor_agent: {~w(attributes creditorAgent), :string},
      creditor_account_reference_type: {~w(attributes creditorAccountReferenceType), :string},
      creditor_account_reference: {~w(attributes creditorAccountReference), :string},
      consent_reference: {~w(attributes consentReference), :string},
      amount: {~w(attributes amount), :float},
      redirect_link: {~w(links redirect), :string},
    ]
  end

  @doc """
  Convenience function for creating a payment initiation request for a financial institution.

  Returns `{:ok, payment_initiation_request}` if successful, `{:error, reason}` otherwise.

  See `create/1`
  """
  def create(%Request{} = request, financial_institution_id) do
    request
    |> Request.resource_type(@resource_type)
    |> Request.id(:financial_institution_id, financial_institution_id)
    |> create
  end

  @doc """
  [Creates a payment initiation request](https://documentation.ibanity.com/api#create-payment-initiation-request) for a financial institution.

  Returns `{:ok, payment_initiation_request}` if successful, `{:error, reason}` otherwise.

  ## Example

      iex> [
      ...>   redirect_uri: "https://fake-tpp.com/payment-initiated",
      ...>   consent_reference: "b57cca6b-74d6-4ac8-ba5d-4e28160d8dde",
      ...>   ...
      ...> ]
      ...> |> Request.attributes
      ...> |> Request.id(:financial_institution_id, "b2c76f6b-ab34-4843-8ef3-84300ef98a09")
      ...> |> PaymentInitiationRequest.create
      {:ok, %Ibanity.PaymentInitiationRequest{id: "270141aa-0c93-42a5-9adf-e2b9a8ab4cea"}}
  """
  def create(%Request{} = request) do
    request
    |> Request.id(:id, "")
    |> Request.resource_type(@resource_type)
    |> Client.execute(:post, @api_schema_path)
  end

  @doc """
  [Retrieves a payment initiation request](https://documentation.ibanity.com/api#get-payment-initiation-request)
  based on its id and the id of the financial institution.

  See `find/1`
  """
  def find(%Request{} = request, financial_institution_id, initiation_request_id) do
    request
    |> Request.id(:id, financial_institution_id)
    |> Request.id(:payment_initiation_request_id, initiation_request_id)
    |> find
  end

  @doc """
  [Retrieves a payment initiation request](https://documentation.ibanity.com/api#get-payment-initiation-request)
  based on its id and the id of the financial institution.

  Returns `{:ok, payment_initiation_request}` if successful, `{:error, reason}` otherwise.

  ## Example

      iex> Request.id(:financial_institution_id, "b2c76f6b-ab34-4843-8ef3-84300ef98a09")
      ...> |> Request.id(:id, "270141aa-0c93-42a5-9adf-e2b9a8ab4cea")
      ...> |> PaymentInitiationRequest.find
      {:ok, %Ibanity.PaymentInitiationRequest{id: "270141aa-0c93-42a5-9adf-e2b9a8ab4cea"}}
  """
  def find(%Request{} = request) do
    request
    |> Client.execute(:get, @api_schema_path)
  end
end
