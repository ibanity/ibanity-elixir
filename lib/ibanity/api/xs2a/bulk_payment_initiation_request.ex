defmodule Ibanity.Xs2a.BulkPaymentInitiationRequest do
  @moduledoc """
  [Bulk payment initiation requests](https://documentation.ibanity.com/xs2a/api#payment-initiation-request) API wrapper
  """

  use Ibanity.Resource

  @api_schema_path ~w(xs2a customer financialInstitution bulkPaymentInitiationRequests)
  @resource_type "bulk_payment_initiation_request"

  defstruct id: nil,
            status: nil,
            product_type: nil,
            end_to_end_id: nil,
            debtor_name: nil,
            debtor_account_reference_type: nil,
            debtor_account_reference: nil,
            consent_reference: nil,
            redirect_link: nil,
            financial_institution_id: nil,
            skip_ibanity_completion_callback: false,
            allow_financial_institution_redirect_uri: false
            payments: []

  defmodule Payment do
    defstruct remittance_information: nil,
              remittance_information_type: nil,
              requested_execution_date: nil,
              currency: nil,
              amount: nil,
              creditor_name: nil,
              creditor_account_reference: nil,
              creditor_account_reference_type: nil,
              creditor_agent: nil,
              creditor_agent_type: nil

    @doc false
    def key_mapping do
      [
        remittance_information: {~w(remittanceInformation), :string},
        remittance_information_type: {~w(remittanceInformationType), :string},
        requested_execution_date: {~w(requestedExecutionDate), :date},
        currency: {~w(currency), :string},
        amount: {~w(amount), :integer},
        creditor_name: {~w(creditorName), :string},
        creditor_account_reference: {~w(creditorAccountReference), :string},
        creditor_account_reference_type: {~w(creditorAccountReferenceType), :string},
        creditor_agent: {~w(creditorAgent), :string},
        creditor_agent_type: {~w(creditorAgentType), :string}
      ]
    end
  end

  @doc false
  def key_mapping do
    [
      id: {~w(id), :string},
      status: {~w(attributes status), :string},
      product_type: {~w(attributes productType), :string},
      end_to_end_id: {~w(attributes endToEndId), :string},
      debtor_name: {~w(attributes debtorName), :string},
      debtor_account_reference_type: {~w(attributes debtorAccountReferenceType), :string},
      debtor_account_reference: {~w(attributes debtorAccountReference), :string},
      skip_ibanity_completion_callback: {~w(attributes skipIbanityCompletionCallback), :boolean},
      allow_financial_institution_redirect_uri:  {~w(attributes allowFinancialInstitutionRedirectUri), :boolean},
      consent_reference: {~w(attributes consentReference), :string},
      redirect_link: {~w(links redirect), :string},
      financial_institution_id: {~w(relationships financialInstitution data id), :string},
      payments: {~w(attributes payments), "paymentItem"}
    ]
  end

  @doc """
  Convenience function for creating a bulk payment initiation request for a financial institution.

  Returns `{:ok, payment_initiation_request}` if successful, `{:error, reason}` otherwise.

  See `create/1`
  """
  def create(%Request{} = request, financial_institution_id) do
    request
    |> Request.resource_type(@resource_type)
    |> Request.id(:financial_institution_id, financial_institution_id)
    |> create()
  end

  @doc """
  [Creates a bulk payment initiation request](https://documentation.ibanity.com/xs2a/api#create-payment-initiation-request) for a financial institution.

  Returns `{:ok, payment_initiation_request}` if successful, `{:error, reason}` otherwise.

  ## Example

      iex> [
      ...>   redirect_uri: "https://fake-tpp.com/payment-initiated",
      ...>   consent_reference: "b57cca6b-74d6-4ac8-ba5d-4e28160d8dde",
      ...>   ...
      ...> ]
      ...> |> Request.attributes
      ...> |> Request.id(:financial_institution_id, "b2c76f6b-ab34-4843-8ef3-84300ef98a09")
      ...> |> BulkPaymentInitiationRequest.create
      {:ok, %Ibanity.BulkPaymentInitiationRequest{id: "270141aa-0c93-42a5-9adf-e2b9a8ab4cea"}}
  """
  def create(%Request{} = request) do
    request
    |> Request.id(:id, "")
    |> Request.resource_type(@resource_type)
    |> Client.execute(:post, @api_schema_path)
  end

  @doc """
  [Retrieves a bulk payment initiation request](https://documentation.ibanity.com/xs2a/api#get-payment-initiation-request)
  based on its id and the id of the financial institution.

  See `find/1`
  """
  def find(%Request{} = request, financial_institution_id, initiation_request_id) do
    request
    |> Request.id(:id, financial_institution_id)
    |> Request.id(:payment_initiation_request_id, initiation_request_id)
    |> find()
  end

  @doc """
  [Retrieves a bulk payment initiation request](https://documentation.ibanity.com/xs2a/api#get-payment-initiation-request)
  based on its id and the id of the financial institution.

  Returns `{:ok, payment_initiation_request}` if successful, `{:error, reason}` otherwise.

  ## Example

      iex> Request.id(:financial_institution_id, "b2c76f6b-ab34-4843-8ef3-84300ef98a09")
      ...> |> Request.id(:id, "270141aa-0c93-42a5-9adf-e2b9a8ab4cea")
      ...> |> BulkPaymentInitiationRequest.find
      {:ok, %Ibanity.Xs2a.PaymentInitiationRequest{id: "270141aa-0c93-42a5-9adf-e2b9a8ab4cea"}}
  """
  def find(%Request{} = request), do: Client.execute(request, :get, @api_schema_path)

  def delete(%Request{} = request), do: Client.execute(request, :delete, @api_schema_path)
end
