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
            errors: [],
            created_at: nil,
            updated_at: nil

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
      customer_online: {~w(attributes customerOnline), :string},
      customer_ip_address: {~w(attributes customerIpAddress), :string},
      errors: {~w(attributes errors), :string},
      created_at: {~w(attributes createdAt), :datetime},
      updated_at: {~w(attributes updatedAt), :datetime}
    ]
  end
end
