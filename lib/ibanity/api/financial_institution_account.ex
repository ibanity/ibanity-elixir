defmodule Ibanity.FinancialInstitutionAccount do
  @moduledoc """
  [Financial institution account](https://documentation.ibanity.com/api#financial-institution-account) API wrapper
  """

  use Ibanity.Resource

  defstruct [
    id: nil,
    available_balance: nil,
    currency: nil,
    current_balance: nil,
    description: nil,
    reference: nil,
    reference_type: nil,
    subtype: nil,
    created_at: nil,
    updated_at: nil
  ]

  @api_schema_path ["sandbox", "financialInstitution", "financialInstitutionAccounts"]

  @doc """
  [Creates a new financial institution account](https://documentation.ibanity.com/api#create-financial-institution-account).

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
  def create(%Request{} = request) do
    request
    |> Request.id(:id, "")
    |> Request.resource_type("financial_institution_account")
    |> Client.execute(:post, @api_schema_path)
  end

  @doc """
  [List all accounts](https://documentation.ibanity.com/api#list-financial-institution-accounts)
  belonging to a user, within a financial institution.

  Returns `{:ok, accounts}` where `accounts` is a `Ibanity.Collection` where items are `Ibanity.FinancialInstitutionAccount`.
  """
  def list(institution_id, user_id) do
    Request.id(:financial_institution_id, institution_id)
    |> Request.id(:financial_institution_user_id, user_id)
    |> list
  end

  @doc """
  [List all accounts](https://documentation.ibanity.com/api#list-financial-institution-accounts)
  belonging to a user, within a financial institution.

  Returns `{:ok, accounts}` where `accounts` is a `Ibanity.Collection` where items are `Ibanity.FinancialInstitutionAccount`.

  ## Examples

      iex> |> Request.id(:financial_institution_id, "b5d6c5f9-e1d2-4cd1-a2aa-7baf964f7bf7")
      ...> |> Request.id(:financial_institution_user_id, "a64f42ec-c801-41a7-8801-0f815ca42e9e")
      ...> |> FinancialInstitutionAccount.list
      {:ok, %Ibanity.Collection{items: [%Ibanity.FinancialInstitutionAccount{...}], ...}}
  """
  def list(%Request{} = request) do
    request
    |> Request.id(:id, "")
    |> Client.execute(:get, @api_schema_path)
  end

  @doc """
  [Retrieves an account](https://documentation.ibanity.com/api#get-financial-institution-account)
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
  def find(institution_id, user_id, account_id) do
    Request.id(:financial_institution_id, institution_id)
    |> Request.id(:financial_institution_user_id, user_id)
    |> Request.id(:id, account_id)
    |> find
  end

  @doc """
  [Retrieves an account](https://documentation.ibanity.com/api#get-financial-institution-account)
  belonging to a user and a financial institution.

  Returns `{:ok, account}` when successful, `{:error, reason}` otherwise.

  ## Example

      iex> Request.id(:financial_institution_id, "b5d6c5f9-e1d2-4cd1-a2aa-7baf964f7bf7")
      ...> |> Request.id(:financial_institution_user_id, "a64f42ec-c801-41a7-8801-0f815ca42e9e")
      ...> |> Request.id(:id, "b1c1e046-309b-49b8-bc5d-c4b1f82f61a7")
      ...> |> FinancialInstitutionAccount.find
      {:ok, Ibanity.FinancialInstitutionAccount{id: "b1c1e046-309b-49b8-bc5d-c4b1f82f61a7", ...}}
  """
  def find(%Request{} = request) do
    request
    |> Client.execute(:get, @api_schema_path)
  end

  @doc """
  [Deletes an account](https://documentation.ibanity.com/api#delete-financial-institution-account)
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
  def delete(institution_id, user_id, account_id) do
    Request.id(:financial_institution_id, institution_id)
    |> Request.id(:financial_institution_user_id, user_id)
    |> Request.id(:id, account_id)
    |> delete
  end

  @doc """
  [Deletes an account](https://documentation.ibanity.com/api#delete-financial-institution-account)
  belonging to a user and a financial institution.

  Returns `{:ok, account}` when successful, `{:error, reason}` otherwise.

  ## Example

      iex> Request.id(:financial_institution_id, "b5d6c5f9-e1d2-4cd1-a2aa-7baf964f7bf7")
      ...> |> Request.id(:financial_institution_user_id, "a64f42ec-c801-41a7-8801-0f815ca42e9e")
      ...> |> Request.id(:id, "b1c1e046-309b-49b8-bc5d-c4b1f82f61a7")
      ...> |> FinancialInstitutionAccount.delete
      {:ok, Ibanity.FinancialInstitutionAccount{id: "b1c1e046-309b-49b8-bc5d-c4b1f82f61a7", ...}}
  """
  def delete(%Request{} = request) do
    request
    |> Client.execute(:delete, @api_schema_path)
  end

  @doc false
  def key_mapping do
    [
      id: ~w(id),
      available_balance: ~w(attributes availableBalance),
      currency: ~w(attributes currency),
      current_balance: ~w(attributes currentBalance),
      description: ~w(attributes description),
      reference: ~w(attributes reference),
      reference_type: ~w(attributes referenceType),
      subtype: ~w(attributes subtype),
      created_at: ~w(attributes createdAt),
      updated_at: ~w(attributes updatedAt)
    ]
  end
end
