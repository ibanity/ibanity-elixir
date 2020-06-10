defmodule Ibanity.Xs2a.FinancialInstitution do
  @moduledoc """
  [Financial institutions](https://documentation.ibanity.com/xs2a/api#financial-institution) API wrapper
  """

  use Ibanity.Resource

  defstruct id: nil,
            sandbox: true,
            name: nil,
            self_link: nil,
            bic: nil,
            logo_url: nil,
            max_requested_account_references: nil,
            min_requested_account_references: nil,
            primary_color: nil,
            secondary_color: nil,
            requires_credential_storage: nil,
            country: nil,
            future_dated_payments_allowed: nil,
            requires_customer_ip_address: nil,
            status: nil,
            bulk_payments_enabled: nil,
            payments_enabled: nil,
            periodic_payments_enabled: nil,
            bulk_payments_product_types: nil,
            payments_product_types: nil,
            periodic_payments_product_types: nil,
            authorization_models: nil

  @resource_type "financial_institution"

  @sandbox_api_schema_path ["sandbox", "financialInstitutions"]
  @find_api_schema_path ["xs2a", "financialInstitutions"]

  @doc """
  Lists all financial institutions in `sandbox` environment.

  See `list/1`
  """
  def list, do: list(%Request{})

  @doc """
  [Lists all financial institutions](https://documentation.ibanity.com/xs2a/api#list-financial-institutions).

  If the request has a valid [customer access token](https://documentation.ibanity.com/xs2a/api#customer-access-token) set,
  it will reach the `live` endpoint of the API and list financial institutions the customer linked to this token belongs to.
  If it's not set it will reach the `sandbox` endpoint.

  Returns `{:ok, collection}` where `collection` is a `Ibanity.Collection` where items are of type `Ibanity.Xs2a.FinancialInstitution`,
  otherwise it returns `{:error, reason}`.

  ## Example

      iex> FinancialInstitution.list
      {:ok, %Ibanity.Collection{items: [%Ibanity.FinancialInstitution{...}], ...}
  """
  def list(%Request{customer_access_token: nil} = request) do
    request
    |> Request.id(:id, "")
    |> Client.execute(:get, ["xs2a", "financialInstitutions"])
  end

  def list(%Request{} = request) do
    request
    |> Client.execute(:get, ["xs2a", "customer", "financialInstitutions"])
  end

  @doc """
  [Retrieves a financial institution](https://documentation.ibanity.com/xs2a/api#get-financial-institution).

  If the argument is a binary, it will create and empty request and assign the value of the id to that argument.

  If it's a request it will use it _as-is_.
  If the request has a valid [customer access token](https://documentation.ibanity.com/xs2a/api#customer-access-token) set,
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
  [Creates a new financial institution](https://documentation.ibanity.com/xs2a/api#create-financial-institution).

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
  [Updates an existing financial institution](https://documentation.ibanity.com/xs2a/api#update-financial-institution).

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
  [Deletes a financial institution](https://documentation.ibanity.com/xs2a/api#delete-financial-institution).

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
      self_link: {~w(links self), :string},
      bic: {~w(attributes bic), :string},
      logo_url: {~w(attributes logoUrl), :string},
      max_requested_account_references: {~w(attributes maxRequestedAccountReferences), :integer},
      min_requested_account_references: {~w(attributes minRequestedAccountReferences), :integer},
      primary_color: {~w(attributes primaryColor), :string},
      secondary_color: {~w(attributes secondaryColor), :string},
      requires_credential_storage: {~w(attributes requiresCredentialStorage), :boolean},
      country: {~w(attributes country), :string},
      future_dated_payments_allowed: {~w(attributes futureDatedPaymentsAllowed), :boolean},
      requires_customer_ip_address: {~w(attributes requiresCustomerIpAddress), :boolean},
      status: {~w(attributes status), :string},
      bulk_payments_enabled: {~w(attributes bulkPaymentsEnabled), :boolean},
      payments_enabled: {~w(attributes paymentsEnabled), :boolean},
      periodic_payments_enabled: {~w(attributes periodicPaymentsEnabled), :boolean},
      bulk_payments_product_types: {~w(attributes bulkPaymentsProductTypes), :struct},
      payments_product_types: {~w(attributes paymentsProductTypes), :struct},
      periodic_payments_product_types: {~w(attributes periodicPaymentsProductTypes), :struct},
      authorization_models: {~w(attributes authorizationModels), :struct}
    ]
  end
end
