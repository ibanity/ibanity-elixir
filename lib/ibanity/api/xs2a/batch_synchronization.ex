defmodule Ibanity.Xs2a.BatchSynchronization do
  @moduledoc """
  [Batch synchronization](https://documentation.ibanity.com/xs2a/api#batch-synchronization) API wrapper
  """

  use Ibanity.Resource

  defstruct id: nil

  @resource_type "batch_synchronization"

  @api_schema_path ["xs2a", "batchSynchronizations"]

  @doc """
  [Creates a new batch synchronization](https://documentation.ibanity.com/xs2a/api#create-batch-synchronization).

  Returns `{:ok, batch_synchronization}` if sucessful, `{:error, reason}` otherwise.

  ## Example

      iex> [
      ...> resourceType: "account",
      ...> subtypes: ["accountDetails", "accountTransactions"]
      ...> ]
      ...> |> Request.attributes
      ...> |> BatchSynchronization.create
      {:ok, %Ibanity.BatchSynchronization{id: "4b52d43c-433d-41e0-96f2-c2e38a24b25e"}}
  """
  def create(%Request{} = request) do
    request
    |> Request.id(:id, "")
    |> Request.resource_type(@resource_type)
    |> Client.execute(:post, @api_schema_path)
  end

  @doc false
  def key_mapping do
    [
      id: {~w(id), :string}
    ]
  end
end
