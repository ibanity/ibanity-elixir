defmodule Ibanity.Xs2a.BatchTransactionDeleteRequest do
  @moduledoc """
  [Batch transaction delete request](https://documentation.ibanity.com/xs2a/api#batch-transaction-delete-request) API wrapper
  """

  use Ibanity.Resource

  defstruct id: nil

  @resource_type "batch_transaction_delete_request"

  @api_schema_path ["xs2a", "batchTransactionDeleteRequest"]

  @doc """
  [Creates a new transaction delete request](https://documentation.ibanity.com/xs2a/api#create-batch-transaction-delete-request).

  Returns `{:ok, batch_transaction_delete_request}` if sucessful, `{:error, reason}` otherwise.

  ## Example

      iex> [
      ...> beforeDate: "2022-01-01T00:00:00.000Z"
      ...> ]
      ...> |> Request.attributes
      ...> |> BatchTransactionDeleteRequest.create
      {:ok, %Ibanity.BatchTransactionDeleteRequest{id: "52f6e1ba-dc90-4530-9eae-2dbc9feea569"}}
  """
  def create(%Request{} = request) do
    request
    |> Client.execute(:post, @api_schema_path)
  end

  @doc false
  def key_mapping do
    [
      id: {~w(id), :string},
      before_date: {~w(attributes beforeDate), :datetime}
    ]
  end
end
