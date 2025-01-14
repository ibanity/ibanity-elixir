defmodule Ibanity.Sandbox.FinancialInstitutionAccount do
  @moduledoc """
  [Financial institution account](https://documentation.ibanity.com/xs2a/api#financial-institution-account) API wrapper
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionAccount instead"

  use Ibanity.Resource

  defstruct id: nil,
            available_balance: nil,
            currency: nil,
            current_balance: nil,
            description: nil,
            reference: nil,
            reference_type: nil,
            subtype: nil,
            created_at: nil,
            updated_at: nil,
            internal_reference: nil,
            product: nil,
            holder_name: nil,
            current_balance_changed_at: nil,
            current_balance_variation_observed_at: nil,
            current_balance_reference_date: nil,
            available_balance_changed_at: nil,
            available_balance_variation_observed_at: nil,
            available_balance_reference_date: nil,
            authorized_at: nil,
            authorization_expiration_expected_at: nil,
            financial_institution_user: nil,
            financial_institution_user_id: nil,
            financial_institution_id: nil,
            transactions: nil

  @doc """
  [Creates a new financial institution account](https://documentation.ibanity.com/xs2a/api#create-financial-institution-account).

  Returns `{:ok, account}` when successful, `{:error, reason}` otherwise.

  ## Example

      iex> [
      ...>   subtype: "checking",
      ...>   reference: "BE456789012",
      ...>   reference_type: "IBAN",
      ...>   description: "Savings account",
      ...>   currency: "EUR"
      ...> ]
      ...> |> Request.attributes
      ...> |> Request.id(:financial_institution_id, "b5d6c5f9-e1d2-4cd1-a2aa-7baf964f7bf7")
      ...> |> Request.id(:financial_institution_user_id, "a64f42ec-c801-41a7-8801-0f815ca42e9e")
      ...> |> FinancialInstitutionAccount.create
      {:ok, %Ibanity.FinancialInstitutionAccount{id: "3034fe85-29ee-4ebc-9a2d-33df4e2f4602", ...}}
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionAccount.create/1 instead"
  def create(%Request{} = request) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionAccount.create(request)
  end

  @doc """
  [List all accounts](https://documentation.ibanity.com/xs2a/api#list-financial-institution-accounts)
  belonging to a user, within a financial institution.

  Returns `{:ok, accounts}` where `accounts` is a `Ibanity.Collection` where items are `Ibanity.FinancialInstitutionAccount`.
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionAccount.list/2 instead"
  def list(financial_institution_id, user_id) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionAccount.list(financial_institution_id, user_id)
  end

  @doc """
  [List all accounts](https://documentation.ibanity.com/xs2a/api#list-financial-institution-accounts)
  belonging to a user, within a financial institution.

  Returns `{:ok, accounts}` where `accounts` is a `Ibanity.Collection` where items are `Ibanity.FinancialInstitutionAccount`.

  ## Examples

      iex> |> Request.id(:financial_institution_id, "b5d6c5f9-e1d2-4cd1-a2aa-7baf964f7bf7")
      ...> |> Request.id(:financial_institution_user_id, "a64f42ec-c801-41a7-8801-0f815ca42e9e")
      ...> |> FinancialInstitutionAccount.list
      {:ok, %Ibanity.Collection{items: [%Ibanity.FinancialInstitutionAccount{...}], ...}}
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionAccount.list/1 instead"
  def list(%Request{} = request) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionAccount.list(request)
  end

  @doc """
  [Retrieves an account](https://documentation.ibanity.com/xs2a/api#get-financial-institution-account)
  belonging to a user and a financial institution.

  Returns `{:ok, account}` when successful, `{:error, reason}` otherwise.

  ## Example

      iex> FinancialInstitutionAccount.find(
      ...>   "b5d6c5f9-e1d2-4cd1-a2aa-7baf964f7bf7",
      ...>   "a64f42ec-c801-41a7-8801-0f815ca42e9e",
      ...>   "b1c1e046-309b-49b8-bc5d-c4b1f82f61a7",
      ...> )
      {:ok, Ibanity.FinancialInstitutionAccount{id: "b1c1e046-309b-49b8-bc5d-c4b1f82f61a7", ...}}
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionAccount.find/3 instead"
  def find(financial_institution_id, user_id, account_id) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionAccount.find(
      financial_institution_id,
      user_id,
      account_id
    )
  end

  @doc """
  [Retrieves an account](https://documentation.ibanity.com/xs2a/api#get-financial-institution-account)
  belonging to a user and a financial institution.

  Returns `{:ok, account}` when successful, `{:error, reason}` otherwise.

  ## Example

      iex> Request.id(:financial_institution_id, "b5d6c5f9-e1d2-4cd1-a2aa-7baf964f7bf7")
      ...> |> Request.id(:financial_institution_user_id, "a64f42ec-c801-41a7-8801-0f815ca42e9e")
      ...> |> Request.id(:id, "b1c1e046-309b-49b8-bc5d-c4b1f82f61a7")
      ...> |> FinancialInstitutionAccount.find
      {:ok, Ibanity.FinancialInstitutionAccount{id: "b1c1e046-309b-49b8-bc5d-c4b1f82f61a7", ...}}
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionAccount.find/1 instead"
  def find(%Request{} = request) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionAccount.find(request)
  end

  @doc """
  [Deletes an account](https://documentation.ibanity.com/xs2a/api#delete-financial-institution-account)
  belonging to a user and a financial institution.

  Returns `{:ok, account}` when successful, `{:error, reason}` otherwise.

  ## Example

      iex> Ibanity.FinancialInstitutionAccount.delete(
      ...>   "b5d6c5f9-e1d2-4cd1-a2aa-7baf964f7bf7",
      ...>   "a64f42ec-c801-41a7-8801-0f815ca42e9e",
      ...>   "b1c1e046-309b-49b8-bc5d-c4b1f82f61a7",
      ...> )
      {:ok, FinancialInstitutionAccount{id: "b1c1e046-309b-49b8-bc5d-c4b1f82f61a7", ...}}
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionAccount.delete/3 instead"
  def delete(financial_institution_id, user_id, account_id) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionAccount.delete(
      financial_institution_id,
      user_id,
      account_id
    )
  end

  @doc """
  [Deletes an account](https://documentation.ibanity.com/xs2a/api#delete-financial-institution-account)
  belonging to a user and a financial institution.

  Returns `{:ok, account}` when successful, `{:error, reason}` otherwise.

  ## Example

      iex> Request.id(:financial_institution_id, "b5d6c5f9-e1d2-4cd1-a2aa-7baf964f7bf7")
      ...> |> Request.id(:financial_institution_user_id, "a64f42ec-c801-41a7-8801-0f815ca42e9e")
      ...> |> Request.id(:id, "b1c1e046-309b-49b8-bc5d-c4b1f82f61a7")
      ...> |> FinancialInstitutionAccount.delete
      {:ok, Ibanity.FinancialInstitutionAccount{id: "b1c1e046-309b-49b8-bc5d-c4b1f82f61a7", ...}}
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionAccount.delete/1 instead"
  def delete(%Request{} = request) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionAccount.delete(request)
  end

  @doc """
  Fetches the transactions associated to this account.

  Returns:
  * `{:ok, transactions}` if successful, where `transactions` is an `Ibanity.Collection`
  * `nil` if no transaction link was set on the structure
  * `{:error, reason}` otherwise
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionAccount.transactions/1 instead"
  def transactions(%__MODULE__{} = account) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionAccount.transactions(account)
  end

  @doc """
  Fetches the financial institution user this account belongs to.

  Returns:
  * `{:ok, institution}` if successful,
  * `nil` if no financial institution user link was set on the structure
  * `{:error, reason}` otherwise
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionAccount.financial_institution_user/1 instead"
  def financial_institution_user(%__MODULE__{} = account) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionAccount.financial_institution_user(account)
  end
end
