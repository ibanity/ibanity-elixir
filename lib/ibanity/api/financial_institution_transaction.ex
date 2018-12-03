defmodule Ibanity.FinancialInstitutionTransaction do
  @moduledoc """
  [Financial institution transaction]() API wrapper
  """

  use Ibanity.Resource

  @api_schema_path ~w(sandbox financialInstitution financialInstitutionAccount financialInstitutionTransactions)
  @resource_type "financial_institution_transaction"

  defstruct id: nil,
            value_date: nil,
            updated_at: nil,
            remittance_information_type: nil,
            remittance_information: nil,
            execution_date: nil,
            description: nil,
            currency: nil,
            created_at: nil,
            counterpart_reference: nil,
            counterpart_name: nil,
            amount: nil

  @doc """
  Convenience function to [create a new financial institution transaction](https://documentation.ibanity.com/api#create-financial-institution-transaction).

  See `create/1`

  ## Example
      iex> attributes = [
      ...>   value_date: "2017-05-22T00:00:00Z",
      ...>   execution_date: "2017-05-25T00:00:00Z",
      ...>   amount: 84.42,
      ...>   remittance_information_type: "NEW SHOES",
      ...>   remittance_information: "unstructured",
      ...>   ...
      ...> ]
      ...> FinancialInstitutionTransaction.create(
      ...>   "ad6fa583-2616-4a11-8b8d-eb98c53e2905",
      ...>   "740b6ae8-a631-4a32-9afc-a5548ab99d7e",
      ...>   "d9d60751-b741-4fa6-8524-8f9a066ca037",
      ...>   attributes
      ...> )
      {:ok, %Ibanity.FinancialInstitutionTransaction{id: "44cd2dc8-163a-4dbe-b544-869e5f84ea54", ...}}
  """
  def create(
        %Request{} = request,
        financial_institution_id,
        financial_institution_user_id,
        financial_institution_account_id,
        attributes
      ) do
    request
    |> Request.attributes(attributes)
    |> Request.id(:financial_institution_id, financial_institution_id)
    |> Request.id(:financial_institution_user_id, financial_institution_user_id)
    |> Request.id(:financial_institution_account_id, financial_institution_account_id)
    |> create
  end

  @doc """
  [Creates a new financial institution transaction](https://documentation.ibanity.com/api#create-financial-institution-transaction).

  Returns `{:ok, transaction}` if successful, `{:error, reason}` otherwise
  """
  def create(%Request{} = request) do
    request
    |> Request.id(:id, "")
    |> Request.resource_type(@resource_type)
    |> Client.execute(:post, @api_schema_path)
  end

  @doc """
  [List transactions]() linked to a financial institution user account

   ## Example
      iex> FinancialInstitutionTransaction.list(
      ...>   "ad6fa583-2616-4a11-8b8d-eb98c53e2905",
      ...>   "740b6ae8-a631-4a32-9afc-a5548ab99d7e",
      ...>   "d9d60751-b741-4fa6-8524-8f9a066ca037"
      ...> )
      %Ibanity.Collection[items: [Ibanity.FinancialInstitutionTransaction{id: "44cd2dc8-163a-4dbe-b544-869e5f84ea54", ...}], ...]
  """
  def list(
        %Request{} = request,
        financial_institution_id,
        financial_institution_user_id,
        financial_institution_account_id
      ) do
    request
    |> Request.id(:financial_institution_id, financial_institution_id)
    |> Request.id(:financial_institution_user_id, financial_institution_user_id)
    |> Request.id(:financial_institution_account_id, financial_institution_account_id)
    |> list
  end

  @doc """
  [Lists transactions](https://documentation.ibanity.com/api#list-financial-institution-transactions) linked to a financial institution user account

  ## Example
      iex> %Request{}
      ...> |> Request.id(:financial_institution_id, "ad6fa583-2616-4a11-8b8d-eb98c53e2905")
      ...> |> Request.id(:financial_institution_user_id, "740b6ae8-a631-4a32-9afc-a5548ab99d7e")
      ...> |> Request.id(:financial_institution_account_id, "d9d60751-b741-4fa6-8524-8f9a066ca037")
      ...> |> FinancialInstitutionTransaction.list
      %Ibanity.Collection[items: [Ibanity.FinancialInstitutionTransaction{id: "44cd2dc8-163a-4dbe-b544-869e5f84ea54", ...}], ...]
  """
  def list(%Request{} = request) do
    request
    |> Request.id(:id, "")
    |> Client.execute(:get, @api_schema_path)
  end

  @doc """
  [Retrieves transaction](https://documentation.ibanity.com/api#get-financial-institution-transaction)

  See `find/1`

  ## Example
      iex> %Request{}
      ...> |> FinancialInstitutionTransaction.find(
      ...>  "ad6fa583-2616-4a11-8b8d-eb98c53e2905",
      ...>  "740b6ae8-a631-4a32-9afc-a5548ab99d7e",
      ...>  "d9d60751-b741-4fa6-8524-8f9a066ca037"
      ...> )
      %{:ok, Ibanity.FinancialInstitutionTransaction{id: "44cd2dc8-163a-4dbe-b544-869e5f84ea54", ...}}
  """
  def find(
        %Request{} = request,
        financial_institution_id,
        financial_institution_user_id,
        financial_institution_account_id,
        financial_institution_transaction_id
      ) do
    request
    |> Request.id(:financial_institution_id, financial_institution_id)
    |> Request.id(:financial_institution_user_id, financial_institution_user_id)
    |> Request.id(:financial_institution_account_id, financial_institution_account_id)
    |> Request.id(:id, financial_institution_transaction_id)
    |> find
  end

  @doc """
  [Retrieves transaction](https://documentation.ibanity.com/api#get-financial-institution-transaction)

  Returns `{:ok, transaction}` if successful, `{:error, reason}` otherwise

  ## Example
      iex> %Request{}
      ...> |> Request.id(:financial_institution_id, "ad6fa583-2616-4a11-8b8d-eb98c53e2905")
      ...> |> Request.id(:financial_institution_user_id, "740b6ae8-a631-4a32-9afc-a5548ab99d7e")
      ...> |> Request.id(:financial_institution_account_id, "d9d60751-b741-4fa6-8524-8f9a066ca037")
      ...> |> Request.id("83e440d7-6bfa-4b08-92b7-c2ae7fc5c0e9")
      ...> |> FinancialInstitutionTransaction.find
      %{:ok, Ibanity.FinancialInstitutionTransaction{id: "44cd2dc8-163a-4dbe-b544-869e5f84ea54", ...}}
  """
  def find(%Request{} = request) do
    request
    |> Client.execute(:get, @api_schema_path)
  end

  @doc """
  [Delete transaction](https://documentation.ibanity.com/api#delete-financial-institution-transaction)

  See `delete/1`

  ## Example
      iex> %Request{}
      ...> |> FinancialInstitutionTransaction.delete(
      ...>  "ad6fa583-2616-4a11-8b8d-eb98c53e2905",
      ...>  "740b6ae8-a631-4a32-9afc-a5548ab99d7e",
      ...>  "d9d60751-b741-4fa6-8524-8f9a066ca037",
      ...>  "83e440d7-6bfa-4b08-92b7-c2ae7fc5c0e9 "
      ...> )
      %{:ok, Ibanity.FinancialInstitutionTransaction{id: "44cd2dc8-163a-4dbe-b544-869e5f84ea54", ...}}
  """
  def delete(
        %Request{} = request,
        financial_institution_id,
        financial_institution_user_id,
        financial_institution_account_id,
        financial_institution_transaction_id
      ) do
    request
    |> Request.id(:financial_institution_id, financial_institution_id)
    |> Request.id(:financial_institution_user_id, financial_institution_user_id)
    |> Request.id(:financial_institution_account_id, financial_institution_account_id)
    |> Request.id(:id, financial_institution_transaction_id)
    |> delete
  end

  @doc """
  [Deletes transaction](https://documentation.ibanity.com/api#delete-financial-institution-transaction)

  Returns `{:ok, transaction}` if successful, `{:error, reason}` otherwise

  ## Example
      iex> %Request{}
      ...> |> Request.id(:financial_institution_id, "ad6fa583-2616-4a11-8b8d-eb98c53e2905")
      ...> |> Request.id(:financial_institution_user_id, "740b6ae8-a631-4a32-9afc-a5548ab99d7e")
      ...> |> Request.id(:financial_institution_account_id, "d9d60751-b741-4fa6-8524-8f9a066ca037")
      ...> |> Request.id("83e440d7-6bfa-4b08-92b7-c2ae7fc5c0e9")
      ...> |> FinancialInstitutionTransaction.delete
      %{:ok, Ibanity.FinancialInstitutionTransaction{id: "44cd2dc8-163a-4dbe-b544-869e5f84ea54", ...}}
  """
  def delete(%Request{} = request) do
    request
    |> Client.execute(:delete, @api_schema_path)
  end

  @doc false
  def key_mapping do
    [
      id: {~w(id), :string},
      value_date: {~w(attributes valueDate), :datetime},
      updated_at: {~w(attributes updatedAt), :datetime},
      remittance_information_type: {~w(attributes remittanceInformationType), :string},
      remittance_information: {~w(attributes remittanceInformation), :string},
      execution_date: {~w(attributes executionDate), :datetime},
      description: {~w(attributes description), :string},
      currency: {~w(attributes currency), :string},
      created_at: {~w(attributes createdAt), :datetime},
      counterpart_reference: {~w(attributes counterpartReference), :string},
      counterpart_name: {~w(attributes counterpartName), :string},
      amount: {~w(attributes amount), :float}
    ]
  end
end
