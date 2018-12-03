defmodule Ibanity.FinancialInstitutionUser do
  @moduledoc """
  [Financial institution user](https://documentation.ibanity.com/api#financial-institution-user) API wrapper
  """

  use Ibanity.Resource

  @api_schema_path ["sandbox", "financialInstitutionUsers"]

  defstruct id: nil,
            first_name: nil,
            last_name: nil,
            login: nil,
            password: nil,
            created_at: nil,
            updated_at: nil

  @resource_type "financial_institution_user"

  @doc """
  [Creates a new financial institution user](https://documentation.ibanity.com/api#create-financial-institution-user).

  Returns `{:ok, user}` when successful, `{:error, reason}` otherwise.

  ## Example

      iex> [
      ...>   login: "jlopez",
      ...>   password: "password",
      ...>   last_name: "Lopez",
      ...>   first_name: "Jane"
      ...> ]
      ...> |> Request.attributes
      ...> |> Ibanity.FinancialInstitutionUser.create
      {:ok, %Ibanity.FinancialInstitutionUser{id: "5178d658-0c33-440a-a3af-616a8e472617", ...}}
  """
  def create(%Request{} = request) do
    request
    |> Request.id(:id, "")
    |> Request.resource_type(@resource_type)
    |> Client.execute(:post, @api_schema_path)
  end

  @doc """
  [Lists all financial institution users](https://documentation.ibanity.com/api#list-financial-institution-users).

  Returns `{:ok, collection}` where `collection` is of type `Ibanity.Collection` and its items are of type `Ibanity.FinancialInstitutionUser`,
  otherwise returns `{:error, reason}`.

  ## Example

      iex> Ibanity.FinancialInstitutionUser.list
      {:ok, %Ibanity.Collection{items: [%Ibanity.FinancialInstitutionUser{...}], ...}}
  """
  def list(%Request{} = request) do
    request
    |> Request.id(:id, "")
    |> Client.execute(:get, @api_schema_path)
  end

  @doc """
  Finds a financial institution user based on its id.

  Returns `{:ok, user}` when successful, `{:error, reason}` otherwise.

  ## Example

      iex>
      ...> |> Request.attribute()
      ...> |> Ibanity.FinancialInstitutionUser.find
      {:ok, %Ibanity.FinancialInstitutionUser{id: "5178d658-0c33-440a-a3af-616a8e472617", ...}}
  """
  def find(%Request{} = request) do
    request
    |> Client.execute(:get, @api_schema_path)
  end

  @doc """
  [Updates a financial institution user](https://documentation.ibanity.com/api#update-financial-institution-user).

  Returns `{:ok, user}` when successful, `{:error, reason}` otherwise.

  ## Example

      iex> [
      ...>   login: "jlopez",
      ...>   password: "password",
      ...>   last_name: "Lopez",
      ...>   first_name: "Jane"
      ...> ]
      ...> |> Request.attributes
      ...> |> Request.id(:id, "0934789d-e177-484f-b197-f60b40b0f9c4")
      ...> |> Ibanity.FinancialInstitutionUser.update
      {:ok, %Ibanity.FinancialInstitutionUser{id: "5178d658-0c33-440a-a3af-616a8e472617", ...}}

  """
  def update(%Request{} = request) do
    request
    |> Request.resource_type(@resource_type)
    |> Client.execute(:patch, @api_schema_path)
  end

  @doc """
  [Deletes a financial institution user](https://documentation.ibanity.com/api#deletefinancial-institution-user).

  Returns `{:ok, user}` when successful, `{:error, reason}` otherwise.

  ## Example

      iex> |> Request.id(:id, "0934789d-e177-484f-b197-f60b40b0f9c4")
      ...> |> Ibanity.FinancialInstitutionUser.update
      {:ok, %Ibanity.FinancialInstitutionUser{id: "5178d658-0c33-440a-a3af-616a8e472617", ...}}
  """
  def delete(%Request{} = request) do
    request
    |> Client.execute(:delete, @api_schema_path)
  end

  @doc false
  def key_mapping do
    [
      id: {~w(id), :string},
      first_name: {~w(attributes firstName), :string},
      last_name: {~w(attributes lastName), :string},
      login: {~w(attributes login), :string},
      password: {~w(attributes password), :string},
      created_at: {~w(attributes createdAt), :datetime},
      updated_at: {~w(attributes updatedAt), :datetime}
    ]
  end
end
