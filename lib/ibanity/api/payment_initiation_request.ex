defmodule Ibanity.PaymentInitiationRequest do
  alias Ibanity.{PaymentInitiationRequest, Request, ResourceOperations}
  alias Ibanity.Client.Request, as: ClientRequest

  @api_schema_path ~w(customer financialInstitution paymentInitiationRequests)
  @resource_type "paymentInitiationRequest"

  defstruct [
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
    amount: nil
  ]

  def key_mapping do
    [
      status: ~w(attributes status),
      remittance_information_type: ~w(attributes remittanceInformationType),
      remittance_information: ~w(attributes remittanceInformation),
      product_type: ~w(attributes productType),
      end_to_end_id: ~w(attributes end_to_end_id),
      debtor_name: ~w(attributes debtorName),
      debtor_account_reference_type: ~w(attributes debtorAccountReferenceType),
      debtor_account_reference: ~w(attributes debtorAccountReference),
      currency: ~w(attributes currency),
      creditor_name: ~w(attributes creditorName),
      creditor_agent_type: ~w(attributes creditorAgentType),
      creditor_agent: ~w(attributes creditorAgent),
      creditor_account_reference_type: ~w(attributes creditorAccourReferenceType),
      creditor_account_reference: ~w(attributes creditorAccountReference),
      consent_reference: ~w(attributes consentReference),
      amount: ~w(attributes amount)
    ]
  end

  def create(%Request{} = request, financial_institution_id) do
    request
    |> Request.id(:financialInstitutionId, financial_institution_id)
    |> create
  end
  def create(%Request{} = request) do
    request
    |> Request.id(:paymentInitiationRequestId, "")
    |> ClientRequest.build(@api_schema_path, @resource_type)
    |> ResourceOperations.create(__MODULE__)
  end

  def find(%Request{} = request, initiation_request_id, institution_id) do
    request
    |> Request.id(:paymentInitiationRequestId, initiation_request_id)
    |> Request.id(:financialInstitutionId, institution_id)
    |> find
  end
  def find(%Request{} = request) do
    request
    |> ClientRequest.build(@api_schema_path, @resource_type)
    |> ResourceOperations.create(__MODULE__)
  end
end