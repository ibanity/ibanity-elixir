defmodule Ibanity.FinancialInstitutionUser do
  @moduledoc """
  Financial institution user API wrapper
  """

  use Ibanity.Resource

  @api_schema_path ["sandbox", "financialInstitutionUsers"]

  defstruct [
    id: nil,
    first_name: nil,
    last_name: nil,
    login: nil,
    password: nil,
    created_at: nil,
    updated_at: nil
  ]

  def create(%Request{} = request) do
    request
    |> Request.id(:id, "")
    |> Client.execute(:post, @api_schema_path)
  end

  def list(%Request{} = request) do
    request
    |> Request.id(:id, "")
    |> Client.execute(:get, @api_schema_path)
  end

  def find(%Request{} = request) do
    request
    |> Client.execute(:get, @api_schema_path)
  end

  def update(%Request{} = request) do
    request
    |> Client.execute(:patch, @api_schema_path)
  end

  def delete(%Request{} = request) do
    request
    |> Client.execute(:delete, @api_schema_path)
  end

  def key_mapping do
    [
      id: ~w(id),
      first_name: ~w(attributes firstName),
      last_name: ~w(attributes lastName),
      login: ~w(attributes login),
      password: ~w(attributes password),
      created_at: ~w(attributes createdAt),
      updated_at: ~w(attributes updatedAt)
    ]
  end
end
