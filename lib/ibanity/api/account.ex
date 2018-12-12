defmodule Ibanity.Account do
  @moduledoc """
  [Accounts](https://documentation.ibanity.com/api#account) API wrapper
  """

  use Ibanity.Resource

  defstruct id: nil,
            subtype: nil,
            reference_type: nil,
            reference: nil,
            description: nil,
            current_balance: nil,
            currency: nil,
            available_balance: nil,
            financial_institution: nil,
            financial_institution_id: nil,
            transactions: nil,
            latest_synchronization: nil,
            synchronized_at: nil

  @doc """
  [List all accounts](https://documentation.ibanity.com/api#list-accounts)
  according to the `financial_institution_id` from the `Ibanity.Request`.

  If `financial_institution_id` is `nil` or is not set, it will list all the accounts.
  If set it will list accounts for that specific financial institution.

  ## Examples

      iex> token
      ...> |> Request.customer_access_token
      ...> |> Account.list
      {:ok, %Ibanity.Collection{items: [...]}}

      iex> token
      ...> |> Request.customer_access_token
      ...> |> Request.id(:financial_institution_id, "0a089c79-bfef-45e7-b647-a4654e4bff9f")
      ...> |> Account.list
      {:ok, %Ibanity.Collection{items: [...]}}
  """
  def list(%Request{} = request),
    do: list(request, Request.get_id(request, :financial_institution_id))

  @doc false
  def list(%Request{} = request, nil) do
    request
    |> Request.id(:id, "")
    |> Client.execute(:get, ["customer", "accounts"])
  end

  @doc """
  [List accounts](https://documentation.ibanity.com/api#list-accounts) for a specific financial institution.

  Returns `{:ok, coll}` with `coll` being an `Ibanity.Collection`
  with `Ibanity.Account` as items, `{:error, reason}`otherwise

  ## Example

      iex> token
      ...> |> Request.customer_access_token
      ...> |> Account.list
  """
  def list(%Request{} = request, financial_institution_id) do
    request
    |> Request.id(:id, "")
    |> Request.id(:financial_institution_id, financial_institution_id)
    |> Client.execute(:get, ["customer", "financialInstitution", "accounts"])
  end

  @doc """
  [Retrieves an account](https://documentation.ibanity.com/api#get-account)
  based on the `financial_institution_id` and `id` (e.g. the account id) stored in the `Ibanity.Request`.

  Returns `{:ok, account}` if found, otherwise `{:error, reason}`

  ## Example

      iex> token
      ...> |> Request.customer_access_token
      ...> |> Request.id(:financial_institution_id, "e1865795-dfa6-4c61-8f1f-1806957ddbdc")
      ...> |> Request.id(:id, "060d959f-e784-4a5b-a5ca-30c857ca0371")
      ...> |> Account.find
      {:ok, %Ibanity.Account{id: "060d959f-e784-4a5b-a5ca-30c857ca0371", ...}}
  """
  def find(%Request{} = request) do
    request
    |> Client.execute(:get, ["customer", "financialInstitution", "accounts"])
  end

  @doc """
  Convenience function to retrieve an account based on the `account_id` `financial_institution_id` given as arguments.

  Returns `{:ok, account}` if found, otherwise `{:error, reason}`

  See `find/1`
  """
  def find(%Request{} = request, account_id, financial_institution_id) do
    request
    |> Request.id(:id, account_id)
    |> Request.id(:financial_institution_id, financial_institution_id)
    |> find
  end

  @doc """
  Convenience function to delete an account based on the `account_id` `financial_institution_id` given as arguments.

  Returns `{:ok, account}` if found, otherwise `{:error, reason}`

  See `delete/1`
  """
  def delete(account_id, financial_institution_id) do
    delete(%Request{}, account_id, financial_institution_id)
  end

  @doc """
  Convenience function to delete an account based on the `account_id` `financial_institution_id` given as arguments.

  Returns `{:ok, account}` if found, otherwise `{:error, reason}`

  See `delete/1`
  """
  def delete(%Request{} = request, account_id, financial_institution_id) do
    request
    |> Request.id(:id, account_id)
    |> Request.id(:financial_institution_id, financial_institution_id)
    |> delete
  end

  @doc """
  [Deletes an account](https://documentation.ibanity.com/api#account)
  based on the `financial_institution_id` and `id` (e.g. the account id) stored in the `Ibanity.Request`.

  Returns `{:ok, account}` if found, otherwise `{:error, reason}`

  ## Example

      iex> token
      ...> |> Request.customer_access_token
      ...> |> Request.id(:financial_institution_id, "e1865795-dfa6-4c61-8f1f-1806957ddbdc")
      ...> |> Request.id(:id, "060d959f-e784-4a5b-a5ca-30c857ca0371")
      ...> |> Account.delete
      {:ok, %Ibanity.Account{id: "060d959f-e784-4a5b-a5ca-30c857ca0371", ...}}
  """
  def delete(%Request{} = request) do
    request
    |> Client.execute(:delete, ["customer", "financialInstitution", "accounts"])
  end

  @doc """
  Fetches the transactions associated to this account.

  Returns:
  * `{:ok, transactions}` if successful, where `transactions` is an `Ibanity.Collection`
  * `nil` if no transaction link was set on the structure
  * `{:error, reason}` otherwise
  """
  def transactions(%__MODULE__{} = account) do
    if account.transactions, do: Client.get(account.transactions), else: nil
  end

  @doc """
  Fetches the financial institution this account belongs to.

  Returns:
  * `{:ok, institution}` if successful,
  * `nil` if no financial institution link was set on the structure
  * `{:error, reason}` otherwise
  """
  def financial_institution(%__MODULE__{} = account) do
    if account.financial_institution, do: Client.get(account.financial_institution), else: nil
  end

  @doc false
  def key_mapping do
    [
      id: {~w(id), :string},
      subtype: {~w(attributes subtype), :string},
      reference_type: {~w(attributes referenceType), :string},
      reference: {~w(attributes reference), :string},
      description: {~w(attributes description), :string},
      current_balance: {~w(attributes currentBalance), :float},
      currency: {~w(attributes currency), :string},
      available_balance: {~w(attributes availableBalance), :float},
      transactions: {~w(relationships transactions links related), :string},
      financial_institution: {~w(relationships financialInstitution links related), :string},
      financial_institution_id: {~w(relationships financialInstitution data id), :string},
      synchronized_at: {~w(meta synchronizedAt), :datetime},
      latest_synchronization: {~w(meta latestSynchronization), :struct}
    ]
  end
end
