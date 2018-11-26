defmodule Ibanity.FinancialInstitution do
  @moduledoc """
  [Financial institutions](https://documentation.ibanity.com/api#financial-institution) API wrapper
  """

  use Ibanity.Resource

  defstruct [
    id: nil,
    sandbox: true,
    name: nil,
    self_link: nil
  ]

  @resource_type "financial_institution"

  @sandbox_api_schema_path ["sandbox", "financialInstitutions"]
  @find_api_schema_path    ["financialInstitutions"]

  @doc """
  Lists all financial institutions in `sandbox` environment.

  See `list/1`
  """
  def list, do: list(%Request{})

  @doc """
  [Lists all financial institutions](https://documentation.ibanity.com/api#list-financial-institutions).

  If the request has a valid [customer access token](https://documentation.ibanity.com/api#customer-access-token) set,
  it will reach the `live` endpoint of the API and list financial institutions the customer linked to this token belongs to.
  If it's not set it will reach the `sandbox` endpoint.

  Returns `{:ok, collection}` where `collection` is a `Ibanity.Collection` where items are of type `Ibanity.FinancialInstitution`,
  otherwise it returns `{:error, reason}`.

  ## Example

      iex> FinancialInstitution.list
      {:ok, %Ibanity.Collection{items: [%Ibanity.FinancialInstitution{...}], ...}
  """
  def list(%Request{customer_access_token: nil} = request) do
    request
    |> Request.id(:id, "")
    |> Client.execute(:get, ["financialInstitutions"])
  end
  def list(%Request{} = request) do
    request
    |> Client.execute(:get, ["customer", "financialInstitutions"])
  end

  @doc """
  [Retrieves a financial institution](https://documentation.ibanity.com/api#get-financial-institution).

  If the argument is a binary, it will create and empty request and assign the value of the id to that argument.

  If it's a request it will use it _as-is_.
  If the request has a valid [customer access token](https://documentation.ibanity.com/api#customer-access-token) set,
  it will reach the `live` endpoint of the API. If it's not set it will reach the `sandbox` endpoint.

  Returns `{:ok, institution}` if sucessful, `{:error, reason}` otherwise.

  ## Examples

      iex> Ibanity.FinancialInstitution.find("55c09df6-0bdd-46ef-8e66-e5297e0e8a7f")
      {:ok, %Ibanity.FinancialInstitution{id: "55c09df6-0bdd-46ef-8e66-e5297e0e8a7f", ...}}

      iex> token
      ...> |> Request.customer_access_token
      ...> |> Request.id(:id, "55c09df6-0bdd-46ef-8e66-e5297e0e8a7f")
      ...> |> FinancialInstitution.find
      {:ok, %Ibanity.FinancialInstitution{id: "55c09df6-0bdd-46ef-8e66-e5297e0e8a7f", ...}}
  """
  def find(id) when is_binary(id), do: find(%Request{resource_ids: [id: id]})
  def find(%Request{} = request) do
    request
    |> Client.execute(:get, @find_api_schema_path)
  end

  @doc """
  [Creates a new financial institution](https://documentation.ibanity.com/api#create-financial-institution).

  Note: work only in `sandbox` environment

  Returns `{:ok, institution}` if sucessful, `{:error, reason}` otherwise.

  ## Example

      iex> [
      ...>   sandbox: true,
      ...>   name: "MetaBank"
      ...> ]
      ...> |> Request.attributes
      ...> |> FinancialInstitution.create
      {:ok, %Ibanity.FinancialInstitution{id: "4b52d43c-433d-41e0-96f2-c2e38a24b25e", ...}}
  """
  def create(%Request{} = request) do
    request
    |> Request.id(:id, "")
    |> Request.resource_type(@resource_type)
    |> Client.execute(:post, @sandbox_api_schema_path)
  end

  @doc """
  [Updates an existing financial institution](https://documentation.ibanity.com/api#update-financial-institution).

  Note: works only in `sandbox` environment

  Returns `{:ok, institution}` if sucessful, `{:error, reason}` otherwise.

  ## Example

      iex> [
      ...>   sandbox: true,
      ...>   name: "metaBank"
      ...> ]
      ...> |> Request.attributes
      ...> |> Request.id(:id, "4b52d43c-433d-41e0-96f2-c2e38a24b25e")
      ...> |> FinancialInstitution.create
      {:ok, %Ibanity.FinancialInstitution{id: "4b52d43c-433d-41e0-96f2-c2e38a24b25e", ...}}
  """
  def update(%Request{} = request) do
    request
    |> Request.resource_type(@resource_type)
    |> Client.execute(:patch, @sandbox_api_schema_path)
  end

  @doc """
  [Deletes a financial institution](https://documentation.ibanity.com/api#delete-financial-institution).

  If the argument is a binary, it will create and empty request and assign the value of the id to that argument.
  If it's a request it will use it _as-is_.

  Note: works only in `sandbox` environment

  Returns `{:ok, institution}` if sucessful, `{:error, reason}` otherwise.

  ## Examples

      iex> Ibanity.FinancialInstitution.delete("55c09df6-0bdd-46ef-8e66-e5297e0e8a7f")
      {:ok, %Ibanity.FinancialInstitution{id: "55c09df6-0bdd-46ef-8e66-e5297e0e8a7f", ...}}

      iex> |> Request.id(:id, "55c09df6-0bdd-46ef-8e66-e5297e0e8a7f")
      ...> |> FinancialInstitution.delete
      {:ok, %Ibanity.FinancialInstitution{id: "55c09df6-0bdd-46ef-8e66-e5297e0e8a7f", ...}}
  """
  def delete(id) when is_binary(id), do: delete(%Request{resource_ids: [id: id]})
  def delete(%Request{} = request) do
    request
    |> Client.execute(:delete, @sandbox_api_schema_path)
  end

  @doc false
  def key_mapping do
    [
      id: {~w(id), :string},
      sandbox: {~w(attributes sandbox), :string},
      name: {~w(attributes name), :string},
      self_link: {~w(links self), :string}
    ]
  end
end
