defmodule Ibanity.PontoConnect.Synchronization do
  @moduledoc """
  [Synchronization](https://documentation.ibanity.com/ponto-connect/api#synchronization) API wrapper
  """

  use Ibanity.Resource

  @api_schema_path ["ponto-connect", "synchronizations"]

  @resource_type "account"

  defstruct [
    :id,
    :subtype,
    :status,
    :resource_id,
    :created_at,
    :updated_at,
    resource_type: @resource_type,
    errors: []
  ]

  alias Ibanity.PontoConnect

  @doc """
  [Creates a new synchronization resource](https://documentation.ibanity.com/ponto-connect/api#create-synchronization).

  *Note that at this moment it only supports `account` as resource type.*

  Returns `{:ok, synchronization}` if successful, `{:error, reason}` otherwise.

  ## Example

  Attributes

      iex> attributes = [  
      ...>   resource_id: "88099509-ce43-4a49-ba98-115af962d96d",
      ...>   subtype: "accountDetails",
      ...>   customer_ip_address: "123.123.123.123"
      ...> ]

  With request

      iex> attributes
      ...> |> Ibanity.Request.attributes()
      ...> |> Ibanity.Request.token(token)
      ...> |> Ibanity.PontoConnect.Synchronization.create()
      {:ok, %Ibanity.PontoConnect.Synchronization{id: "f92fc927-7c39-48c1-aa4b-2820efbfed00"}}

  With token

      iex> Ibanity.PontoConnect.Synchronization.create(token, attributes)
      {:ok, %Ibanity.PontoConnect.Synchronization{id: "f92fc927-7c39-48c1-aa4b-2820efbfed00"}}
  """
  def create(%PontoConnect.Token{} = request_or_token, attrs) do
    request_or_token
    |> Request.token()
    |> create(attrs)
  end

  def create(%Request{token: token} = request_or_token, attrs) when not is_nil(token) do
    request_or_token
    |> Request.attributes(attrs)
    |> create()
  end

  def create(other, _attrs) do
    raise ArgumentError,
      message: PontoConnect.Exceptions.token_argument_error_msg("Synchronization", other)
  end

  @doc """
  Same as create/2, but `:attributes` and `:token` must be set in request.

  ## Examples

  Attributes

      iex> attributes = [  
      ...>   resource_id: "88099509-ce43-4a49-ba98-115af962d96d",
      ...>   subtype: "accountDetails",
      ...>   customer_ip_address: "123.123.123.123"
      ...> ]

  Set attributes and token to create a synchronization

      iex> attributes
      ...> |> Ibanity.Request.attributes()
      ...> |> Ibanity.Request.token(token)
      ...> |> Ibanity.PontoConnect.Synchronization.create()
      {:ok, %Ibanity.PontoConnect.Synchronization{id: "f92fc927-7c39-48c1-aa4b-2820efbfed00"}}
  """
  def create(%Request{} = request) do
    request
    |> Request.id("")
    |> Request.attribute(:resource_type, @resource_type)
    |> Request.resource_type(@resource_type)
    |> Client.execute(:post, @api_schema_path, __MODULE__)
  end

  @doc """
  [Find Synchronization by id](https://documentation.ibanity.com/ponto-connect/2/api#get-synchronization)

  Takes a `Ibanity.PontoConnect.Token`, or a `Ibanity.Request` with set `:token` as first argument, and a Synchronization
  ID as second argument.

  ## Examples

      iex> token
      ...> |> Ibanity.PontoConnect.Synchronization.find("953934eb-229a-4fd2-8675-07794078cc7d")
      {:ok, %Ibanity.PontoConnect.Synchronization{id: "953934eb-229a-4fd2-8675-07794078cc7d"}}

      iex> token
      ...> |> Ibanity.Request.token()
      ...> |> Ibanity.Request.application(:my_application)
      ...> |> Ibanity.PontoConnect.Synchronization.find("953934eb-229a-4fd2-8675-07794078cc7d")
      {:ok, %Ibanity.PontoConnect.Synchronization{id: "953934eb-229a-4fd2-8675-07794078cc7d"}}

      iex> Ibanity.PontoConnect.Synchronization.find(token, "does-not-exist")
      {:error,
        [
          %{
            "code" => "resourceNotFound",
            "detail" => "The requested resource was not found.",
            "meta" => %{
              "requestId" => "00077F00000184847F0000011F4066E44223327005A",
              "resource" => "synchronization"
            }
          }
        ]}
  """
  def find(%Request{token: token} = request_or_token, id)
      when not is_nil(token) do
    request_or_token
    |> Request.id(id)
    |> Client.execute(:get, @api_schema_path, __MODULE__)
  end

  def find(%PontoConnect.Token{} = request_or_token, id) do
    request_or_token
    |> Request.token()
    |> find(id)
  end

  def find(other, _id) do
    raise ArgumentError,
      message: PontoConnect.Exceptions.token_argument_error_msg("Synchronization", other)
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
      updated_pending_transactions:
        {~w(relationships updatedPendingTransactions links related), :string},
      updated_transactions: {~w(relationships updatedTransactions links related), :string}
    ]
  end
end
