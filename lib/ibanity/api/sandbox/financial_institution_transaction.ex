defmodule Ibanity.Sandbox.FinancialInstitutionTransaction do
  @moduledoc """
  [Financial institution transaction]() API wrapper
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionTransaction"

  use Ibanity.Resource

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
            amount: nil,
            internal_reference: nil,
            bank_transaction_code: nil,
            proprietary_bank_transaction_code: nil,
            end_to_end_id: nil,
            purpose_code: nil,
            mandate_id: nil,
            creditor_id: nil,
            additional_information: nil,
            fee: nil,
            card_reference: nil,
            card_reference_type: nil,
            financial_institution_account_id: nil,
            automatic_booking: nil

  @doc """
  Convenience function to [create a new financial institution transaction](https://documentation.ibanity.com/xs2a/api#create-financial-institution-transaction).

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
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionTransaction.create/5 instead"
  def create(
        %Request{} = request,
        financial_institution_id,
        financial_institution_user_id,
        financial_institution_account_id,
        attributes
      ) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionTransaction.create(request,
      financial_institution_id,
      financial_institution_user_id,
      financial_institution_account_id,
      attributes
    )
  end

  @doc """
  [Creates a new financial institution transaction](https://documentation.ibanity.com/xs2a/api#create-financial-institution-transaction).

  Returns `{:ok, transaction}` if successful, `{:error, reason}` otherwise
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionTransaction.create/1 instead"
  def create(%Request{} = request) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionTransaction.create(request)
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
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionTransaction.list/4 instead"
  def list(
        %Request{} = request,
        financial_institution_id,
        financial_institution_user_id,
        financial_institution_account_id
      ) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionTransaction.list(request,
      financial_institution_id,
      financial_institution_user_id,
      financial_institution_account_id
    )
  end

  @doc """
  [Lists transactions](https://documentation.ibanity.com/xs2a/api#list-financial-institution-transactions) linked to a financial institution user account

  ## Example
      iex> %Request{}
      ...> |> Request.id(:financial_institution_id, "ad6fa583-2616-4a11-8b8d-eb98c53e2905")
      ...> |> Request.id(:financial_institution_user_id, "740b6ae8-a631-4a32-9afc-a5548ab99d7e")
      ...> |> Request.id(:financial_institution_account_id, "d9d60751-b741-4fa6-8524-8f9a066ca037")
      ...> |> FinancialInstitutionTransaction.list
      %Ibanity.Collection[items: [Ibanity.FinancialInstitutionTransaction{id: "44cd2dc8-163a-4dbe-b544-869e5f84ea54", ...}], ...]
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionTransaction.list/1 instead"
  def list(%Request{} = request) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionTransaction.list(request)
  end

  @doc """
  [Retrieves transaction](https://documentation.ibanity.com/xs2a/api#get-financial-institution-transaction)

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
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionTransaction.find/5 instead"
  def find(
        %Request{} = request,
        financial_institution_id,
        financial_institution_user_id,
        financial_institution_account_id,
        financial_institution_transaction_id
      ) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionTransaction.find(request,
      financial_institution_id,
      financial_institution_user_id,
      financial_institution_account_id,
      financial_institution_transaction_id
    )
  end

  @doc """
  [Retrieves transaction](https://documentation.ibanity.com/xs2a/api#get-financial-institution-transaction)

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
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionTransaction.find/1 instead"
  def find(%Request{} = request) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionTransaction.find(request)
  end

  @doc """
  [Update transaction](https://documentation.ibanity.com/xs2a/api#update-financial-institution-transaction)

  See `update/1`

  ## Example
      iex> attributes = [
      ...>   value_date: "2017-05-22T00:00:00Z",
      ...>   execution_date: "2017-05-25T00:00:00Z",
      ...>   amount: 84.42,
      ...>   remittance_information_type: "NEW SHOES",
      ...>   remittance_information: "unstructured",
      ...>   ...
      ...> ]
      ...> FinancialInstitutionTransaction.update(
      ...>   "ad6fa583-2616-4a11-8b8d-eb98c53e2905",
      ...>   "740b6ae8-a631-4a32-9afc-a5548ab99d7e",
      ...>   "d9d60751-b741-4fa6-8524-8f9a066ca037",
      ...>   "b59c4b50-3188-41df-9f69-92777a056fe6",
      ...>   attributes
      ...> )
      {:ok, %Ibanity.FinancialInstitutionTransaction{id: "44cd2dc8-163a-4dbe-b544-869e5f84ea54", ...}}
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionTransaction.update/6 instead"
  def update(
        %Request{} = request,
        financial_institution_id,
        financial_institution_user_id,
        financial_institution_account_id,
        financial_institution_transaction_id,
        attributes
      ) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionTransaction.update(request,
      financial_institution_id,
      financial_institution_user_id,
      financial_institution_account_id,
      financial_institution_transaction_id,
      attributes
    )
  end

  @doc """
  [Updates an existing financial institution transaction](https://documentation.ibanity.com/xs2a/api#update-financial-institution-transaction).

  iex> %Request{}
      ...> |> Request.id(:financial_institution_id, "ad6fa583-2616-4a11-8b8d-eb98c53e2905")
      ...> |> Request.id(:financial_institution_user_id, "740b6ae8-a631-4a32-9afc-a5548ab99d7e")
      ...> |> Request.id(:financial_institution_account_id, "d9d60751-b741-4fa6-8524-8f9a066ca037")
      ...> |> Request.id(:financial_institution_transaction_id, "83e440d7-6bfa-4b08-92b7-c2ae7fc5c0e9")
      ...> |> FinancialInstitutionTransaction.update

  Returns `{:ok, transaction}` if successful, `{:error, reason}` otherwise
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionTransaction.update/1 instead"
  def update(%Request{} = request) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionTransaction.update(request)
  end

  @doc """
  [Delete transaction](https://documentation.ibanity.com/xs2a/api#delete-financial-institution-transaction)

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
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionTransaction.delete/5 instead"
  def delete(
        %Request{} = request,
        financial_institution_id,
        financial_institution_user_id,
        financial_institution_account_id,
        financial_institution_transaction_id
      ) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionTransaction.delete(request,
      financial_institution_id,
      financial_institution_user_id,
      financial_institution_account_id,
      financial_institution_transaction_id
    )
  end

  @doc """
  [Deletes transaction](https://documentation.ibanity.com/xs2a/api#delete-financial-institution-transaction)

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
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionTransaction.delete/1 instead"
  def delete(%Request{} = request) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionTransaction.delete(request)
  end
end
