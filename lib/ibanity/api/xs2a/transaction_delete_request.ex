defmodule Ibanity.Xs2a.TransactionDeleteRequest do
  @moduledoc """
  [Transaction delete requests](https://documentation.ibanity.com/xs2a/api#transaction-delete-request) API wrapper
  """

  use Ibanity.Resource

  defstruct id: nil

  @resource_type "transaction_delete_request"

  @doc """
  [Creates a new transaction delete request] for financial institution and account(https://documentation.ibanity.com/xs2a/api#create-transaction-delete-request-for-account).

  Returns `{:ok, transaction_delete_request}` if sucessful, `{:error, reason}` otherwise.

  ## Example

      iex> "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9..."
      ...> |> Request.customer_access_token
      ...> |> Request.attribute("before_date", "2022-01-01T00:00:00.000Z")
      ...> |> TransactionDeleteRequest.create("b2c76f6b-ab34-4843-8ef3-84300ef98a09", "616a75d4-0262-4edc-b168-200c9773d8f8")
      {:ok, %TransactionDeleteRequest{id: "9c57df52-bd8e-42d2-b15a-a664741e3ed2"}}
  """
  def create(%Request{} = request, financial_institution_id, account_id) do
    request
    |> Request.resource_type(@resource_type)
    |> Request.id(:financial_institution_id, financial_institution_id)
    |> Request.id(:account_id, account_id)
    |> Client.execute(:post, ~w(xs2a customer financialInstitution account transactionDeleteRequests))
  end

  @doc """
  [Creates a new transaction delete request] for financial institution and account(https://documentation.ibanity.com/xs2a/api#create-transaction-delete-request-for-account).

  Returns `{:ok, transaction_delete_request}` if sucessful, `{:error, reason}` otherwise.

  ## Example

      iex> "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9..."
      ...> |> Request.customer_access_token
      ...> |> Request.attribute("before_date", "2022-01-01T00:00:00.000Z")
      ...> |> Request.ids([financial_institution_id: "b2c76f6b-ab34-4843-8ef3-84300ef98a09", account_id: "616a75d4-0262-4edc-b168-200c9773d8f8"])
      ...> |> TransactionDeleteRequest.create
      {:ok, %TransactionDeleteRequest{id: "9c57df52-bd8e-42d2-b15a-a664741e3ed2"}}
  """
  def create(%Request{resource_ids: [financial_institution_id: financial_institution_id, account_id: account_id]} = request) do
    request
    |> Request.resource_type(@resource_type)
    |> Request.id(:financial_institution_id, financial_institution_id)
    |> Request.id(:account_id, account_id)
    |> Client.execute(:post, ~w(xs2a customer financialInstitution account transactionDeleteRequests))
  end

  @doc """
  [Creates a new transaction delete request] for application(https://documentation.ibanity.com/xs2a/api#create-transaction-delete-request-for-application).

  Returns `{:ok, transaction_delete_request}` if sucessful, `{:error, reason}` otherwise.

  ## Example

      iex> [before_date: "2022-01-01T00:00:00.000Z"]
      ...> |> Request.attributes
      ...> |> TransactionDeleteRequest.create
      {:ok, %TransactionDeleteRequest{id: "9c57df52-bd8e-42d2-b15a-a664741e3ed2"}}
  """
  def create(%Request{customer_access_token: nil} = request) do
    request
    |> Request.resource_type(@resource_type)
    |> Client.execute(:post, ~w(xs2a transactionDeleteRequests))
  end

  @doc """
  [Creates a new transaction delete request] for customer(https://documentation.ibanity.com/xs2a/api#create-transaction-delete-request-for-customer).

  Returns `{:ok, transaction_delete_request}` if sucessful, `{:error, reason}` otherwise.

  ## Example

      iex> "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9..."
      ...> |> Request.customer_access_token
      ...> |> Request.attribute(before_date, "2022-01-01T00:00:00.000Z")
      ...> |> TransactionDeleteRequest.create
      {:ok, %TransactionDeleteRequest{id: "9c57df52-bd8e-42d2-b15a-a664741e3ed2"}}
  """
  def create(%Request{} = request) do
    request
    |> Request.resource_type(@resource_type)
    |> Client.execute(:post, ~w(xs2a customer transactionDeleteRequests))
  end

  @doc false
  def key_mapping do
    [
      id: {~w(id), :string},
      before_date: {~w(attributes beforeDate), :datetime}
    ]
  end
end
