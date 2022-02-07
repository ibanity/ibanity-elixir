defmodule Ibanity.Xs2a.Synchronization do
  @moduledoc """
  [Synchronization](https://documentation.ibanity.com/xs2a/api#synchronization) API wrapper
  """

  use Ibanity.Resource

  @api_schema_path ~w(xs2a customer synchronizations)

  # Please note that this is NOT the same as the 'resource_type' defined in the struct
  @resource_type "synchronization"

  defstruct id: nil,
            subtype: nil,
            status: nil,
            resource_type: nil,
            resource_id: nil,
            customer_online: nil,
            customer_ip_address: nil,
            updated_transactions: nil,
            errors: [],
            created_at: nil,
            updated_at: nil

  @doc """
  [Lists account's transactions synchronizations](https://documentation.ibanity.com/xs2a/api#list-synchronizations) for a specific account information access request authorization.

  Returns `{:ok, collection}` where `collection` is a `Ibanity.Collection` where items are of type `Ibanity.Xs2a.Synchronization`.

  ## Example

      iex> Request.id(:financial_institution_id, "0f88f06c-3cfe-4b8f-9338-69981c0c4632")
      ...> |> Request.id(:account_information_access_request_id, "ce3893cd-fff5-435a-bdfc-d55a7e98df6f")
      ...> |> Synchronization.list
      {:ok, %Ibanity.Collection{items: [%Ibanity.Synchronization{...}], ...}}
  """
  def list(%Request{resource_ids: [financial_institution_id: _financial_institution_id, account_information_access_request_id: _account_information_access_request_id]} = request) do
    request
    |> Client.execute(:get, ["xs2a", "customer", "financialInstitution", "accountInformationAccessRequest", "initialAccountTransactionsSynchronizations"])
  end

  @doc """
  [Creates a new synchronization resource](https://documentation.ibanity.com/xs2a/api#create-synchronization).

  *Note that at this moment it only supports `account` as resource type.*

  Returns `{:ok, synchronization}` if successful, `{:error, reason}` otherwise.

  ## Example

      iex> [
      ...>   resource_type: "account",
      ...>   resource_id: "88099509-ce43-4a49-ba98-115af962d96d",
      ...>   subtype: "accountDetails"
      ...> ]
      ...> |> Request.attributes
      ...> |> Request.customer_access_token("...")
      ...> |> Synchronization.create
      {:ok, %Ibanity.Xs2a.Synchronization{id: "f92fc927-7c39-48c1-aa4b-2820efbfed00", ...}}
  """
  def create(%Request{} = request) do
    request
    |> Request.id("")
    |> Request.resource_type(@resource_type)
    |> Client.execute(:post, @api_schema_path)
  end

  @doc """
  [Retrieves a synchronization resource](https://documentation.ibanity.com/xs2a/api#get-synchronization).

  Returns `{:ok, synchronization}` if successful, `{:error, reason}` otherwise.

  ## Example

      iex> Request.id("0516f501-4a1c-4e37-8716-758f2bff8e37")
      ...> |> Request.customer_access_token("...")
      ...> |> Synchronization.find
      {:ok, %Ibanity.Xs2a.Synchronization{id: "0516f501-4a1c-4e37-8716-758f2bff8e37"}}
  """
  def find(%Request{} = request) do
    request
    |> Client.execute(:get, @api_schema_path)
  end

  @doc false
  def key_mapping do
    [
      id: {~w(id), :string},
      subtype: {~w(attributes subtype), :string},
      status: {~w(attributes status), :string},
      resource_type: {~w(attributes resourceType), :string},
      resource_id: {~w(attributes resourceId), :string},
      customer_online: {~w(attributes customerOnline), :boolean},
      customer_ip_address: {~w(attributes customerIpAddress), :string},
      errors: {~w(attributes errors), :string},
      created_at: {~w(attributes createdAt), :datetime},
      updated_at: {~w(attributes updatedAt), :datetime},
      updated_transactions: {~w(relationships updatedTransactions links related), :string}
    ]
  end
end
