defmodule Ibanity.Transaction do
  @moduledoc """
  [Transactions](https://documentation.ibanity.com/api#transaction) API wrapper
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
            self: nil

  @api_schema_path ~w(customer financialInstitution transactions)

  @doc """
  [Lists transactions](https://documentation.ibanity.com/api#list-transactions)
  linked to an account belonging to a financial institution.

  Returns `{:ok, collection}` where `collection` is a `Ibanity.Collection` where items are of type `Ibanity.Transaction`.

  ## Example

      iex> Request.id(:financial_institution_id, "0f88f06c-3cfe-4b8f-9338-69981c0c4632")
      ...> |> Request.id(:account_id, "ce3893cd-fff5-435a-bdfc-d55a7e98df6f")
      ...> |> Transaction.list
      {:ok, %Ibanity.Collection{items: [%Ibanity.Transaction{...}], ...}}
  """
  def list(%Request{} = request) do
    request
    |> Request.id(:id, "")
    |> Client.execute(:get, @api_schema_path)
  end

  @doc """
  [Retrieves a transaction](https://documentation.ibanity.com/api#get-transaction)
  linked to an account belonging to an account, based on its id.

  Returns `{:ok, transaction}` if successful, {:error, reason} otherwise.

  ## Example

      iex> Request.id(:financial_institution_id, "0f88f06c-3cfe-4b8f-9338-69981c0c4632")
      ...> |> Request.id(:account_id, "ce3893cd-fff5-435a-bdfc-d55a7e98df6f")
      ...> |> Request.id(:id, "9536e9f2-4ee6-4336-b035-40fc2a0424e4")
      ...> |> Transaction.find
      {:ok, %Ibanity.Transaction{id: "9536e9f2-4ee6-4336-b035-40fc2a0424e4", ...}}

  """
  def find(%Request{} = request) do
    request
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
      self: {~w(links self), :string}
    ]
  end
end
