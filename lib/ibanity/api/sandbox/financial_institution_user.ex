defmodule Ibanity.Sandbox.FinancialInstitutionUser do
  @moduledoc """
  [Financial institution user](https://documentation.ibanity.com/xs2a/api#financial-institution-user) API wrapper
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionUser instead"

  use Ibanity.Resource

  defstruct id: nil,
            first_name: nil,
            last_name: nil,
            login: nil,
            password: nil,
            created_at: nil,
            updated_at: nil

  @doc """
  [Creates a new financial institution user](https://documentation.ibanity.com/xs2a/api#create-financial-institution-user).

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
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionUser.create/1 instead"
  def create(%Request{} = request) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionUser.create(request)
  end

  @doc """
  [Lists all financial institution users](https://documentation.ibanity.com/xs2a/api#list-financial-institution-users).

  Returns `{:ok, collection}` where `collection` is of type `Ibanity.Collection` and its items are of type `Ibanity.FinancialInstitutionUser`,
  otherwise returns `{:error, reason}`.

  ## Example

      iex> Ibanity.FinancialInstitutionUser.list
      {:ok, %Ibanity.Collection{items: [%Ibanity.FinancialInstitutionUser{...}], ...}}
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionUser.list/1 instead"
  def list(%Request{} = request) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionUser.list(request)
  end
  def list, do: list(%Request{})

  @doc """
  Finds a financial institution user based on its id.

  Returns `{:ok, user}` when successful, `{:error, reason}` otherwise.

  ## Example

      iex>
      ...> |> Request.attribute()
      ...> |> Ibanity.FinancialInstitutionUser.find
      {:ok, %Ibanity.FinancialInstitutionUser{id: "5178d658-0c33-440a-a3af-616a8e472617", ...}}
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionUser.find/1 instead"
  def find(%Request{} = request) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionUser.find(request)
  end

  @doc """
  [Updates a financial institution user](https://documentation.ibanity.com/xs2a/api#update-financial-institution-user).

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
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionUser.update/1 instead"
  def update(%Request{} = request) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionUser.update(request)
  end

  @doc """
  [Deletes a financial institution user](https://documentation.ibanity.com/xs2a/api#deletefinancial-institution-user).

  Returns `{:ok, user}` when successful, `{:error, reason}` otherwise.

  ## Example

      iex> |> Request.id(:id, "0934789d-e177-484f-b197-f60b40b0f9c4")
      ...> |> Ibanity.FinancialInstitutionUser.update
      {:ok, %Ibanity.FinancialInstitutionUser{id: "5178d658-0c33-440a-a3af-616a8e472617", ...}}
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionUser.delete/1 instead"
  def delete(%Request{} = request) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionUser.delete(request)
  end
end
