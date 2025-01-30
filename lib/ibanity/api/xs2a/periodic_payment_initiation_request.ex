defmodule Ibanity.Xs2a.PeriodicPaymentInitiationRequest do
  @moduledoc """
  [Payment initiation requests](https://documentation.ibanity.com/xs2a/api#payment-initiation-request) API wrapper
  """

  use Ibanity.Resource

  @api_schema_path ~w(xs2a customer financialInstitution periodicPaymentInitiationRequests)
  @resource_type "periodic_payment_initiation_request"

  defstruct id: nil,
            errors: [],
            status: nil,
            status_reason: nil,
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
            redirect_link: nil,
            financial_institution_id: nil,
            start_date: nil,
            end_date: nil,
            execution_rule: nil,
            frequency: nil,
            skip_ibanity_completion_callback: false,
            allow_financial_institution_redirect_uri: false

  @doc false
  def key_mapping do
    [
      id: {~w(id), :string},
      errors: {~w(attributes errors), :array},
      status: {~w(attributes status), :string},
      status_reason: {~w(attributes status_reason), :string},
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
      financial_institution_id: {~w(relationships financialInstitution data id), :string},
      frequency: {~w(attributes frequency), :string},
      start_date: {~w(attributes startDate), :date},
      end_date: {~w(attributes endDate), :date},
      execution_rule: {~w(attributes executionRule), :string},
      skip_ibanity_completion_callback: {~w(attributes skipIbanityCompletionCallback), :boolean},
      allow_financial_institution_redirect_uri:
        {~w(attributes allowFinancialInstitutionRedirectUri), :boolean}
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
  [Creates a payment initiation request](https://documentation.ibanity.com/xs2a/api#create-payment-initiation-request) for a financial institution.

  Returns `{:ok, payment_initiation_request}` if successful, `{:error, reason}` otherwise.

  ## Example

      iex> [
      ...>   redirect_uri: "https://fake-tpp.com/payment-initiated",
      ...>   consent_reference: "b57cca6b-74d6-4ac8-ba5d-4e28160d8dde",
      ...>   ...
      ...> ]
      ...> |> Request.attributes
      ...> |> Request.id(:financial_institution_id, "b2c76f6b-ab34-4843-8ef3-84300ef98a09")
      ...> |> PeriodicPaymentInitiationRequest.create
      {:ok, %Ibanity.PeriodicPaymentInitiationRequest{id: "270141aa-0c93-42a5-9adf-e2b9a8ab4cea"}}
  """
  def create(%Request{} = request) do
    request
    |> Request.id(:id, "")
    |> Request.resource_type(@resource_type)
    |> Client.execute(:post, @api_schema_path)
  end

  @doc """
  [Retrieves a payment initiation request](https://documentation.ibanity.com/xs2a/api#get-payment-initiation-request)
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
  [Retrieves a payment initiation request](https://documentation.ibanity.com/xs2a/api#get-payment-initiation-request)
  based on its id and the id of the financial institution.

  Returns `{:ok, payment_initiation_request}` if successful, `{:error, reason}` otherwise.

  ## Example

      iex> Request.id(:financial_institution_id, "b2c76f6b-ab34-4843-8ef3-84300ef98a09")
      ...> |> Request.id(:id, "270141aa-0c93-42a5-9adf-e2b9a8ab4cea")
      ...> |> PeriodicPaymentInitiationRequest.find
      {:ok, %Ibanity.Xs2a.PeriodicPaymentInitiationRequest{id: "270141aa-0c93-42a5-9adf-e2b9a8ab4cea"}}
  """
  def find(%Request{} = request) do
    request
    |> Client.execute(:get, @api_schema_path)
  end

  def delete(%Request{} = request) do
    request
    |> Client.execute(:delete, @api_schema_path)
  end
end
