defmodule Ibanity.Xs2a.UpdatedTransaction do
  @moduledoc """
  [Transactions](https://documentation.ibanity.com/xs2a/api#updated-transaction) API wrapper
  """

  use Ibanity.Resource

  defstruct id: nil,
            value_date: nil,
            remittance_information_type: nil,
            remittance_information: nil,
            execution_date: nil,
            description: nil,
            currency: nil,
            counterpart_reference: nil,
            counterpart_name: nil,
            amount: nil,
            internal_reference: nil,
            bank_transaction_code: nil,
            proprietary_bank_transaction_code: nil,
            end_to_end_id: nil,
            purpose_code: nil,
            mandate_id: nil,
            creditor_id: nil,
            digest: nil,
            additional_information: nil,
            account_id: nil,
            self: nil

  @api_schema_path ~w(xs2a synchronization updatedTransactions)

  @doc """
  [Lists transactions](https://documentation.ibanity.com/xs2a/api#list-updated-transactions)
  linked to an account belonging to a financial institution.

  Returns `{:ok, collection}` where `collection` is a `Ibanity.Collection` where items are of type `Ibanity.Xs2a.Transaction`.

  ## Example

      iex> Request.id(:synchronization_id, "0f88f06c-3cfe-4b8f-9338-69981c0c4632")
      ...> |> UpdatedTransaction.list
      {:ok, %Ibanity.Collection{items: [%Ibanity.Transaction{...}], ...}}
  """
  def list(%Request{} = request) do
    request
    |> Request.id(:id, "")
    |> Client.execute(:get, @api_schema_path)
  end

  @doc false
  def key_mapping do
    [
      id: {~w(id), :string},
      value_date: {~w(attributes valueDate), :datetime},
      remittance_information_type: {~w(attributes remittanceInformationType), :string},
      remittance_information: {~w(attributes remittanceInformation), :string},
      execution_date: {~w(attributes executionDate), :datetime},
      description: {~w(attributes description), :string},
      currency: {~w(attributes currency), :string},
      counterpart_reference: {~w(attributes counterpartReference), :string},
      counterpart_name: {~w(attributes counterpartName), :string},
      amount: {~w(attributes amount), :string},
      internal_reference: {~w(attributes internalReference), :string},
      bank_transaction_code: {~w(attributes bankTransactionCode), :string},
      proprietary_bank_transaction_code: {~w(attributes proprietaryBankTransactionCode), :string},
      end_to_end_id: {~w(attributes endToEndId), :string},
      purpose_code: {~w(attributes purposeCode), :string},
      mandate_id: {~w(attributes mandateId), :string},
      creditor_id: {~w(attributes creditorId), :string},
      digest: {~w(attributes digest), :string},
      additional_information: {~w(attributes additionalInformation), :string},
      account_id: {~w(relationships account data id), :string},
      self: {~w(links self), :string}
    ]
  end
end
