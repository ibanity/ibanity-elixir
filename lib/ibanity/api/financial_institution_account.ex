defmodule Ibanity.FinancialInstitutionAccount do
  @moduledoc """
  Financial institution account API wrapper
  """

  use Ibanity.Resource

  defstruct [
    id: nil,
    available_balance: nil,
    currency: nil,
    current_balance: nil,
    description: nil,
    reference: nil,
    reference_type: nil,
    subtype: nil,
    created_at: nil,
    updated_at: nil
  ]

  @api_schema_path ["sandbox", "financialInstitution", "financialInstitutionAccounts"]

  def create(%Request{} = request) do
    request
    |> Request.id(:id, "")
    |> Request.resource_type("financialInstitutionAccount")
    |> Client.execute(:post, @api_schema_path, __MODULE__)
  end

  def list(institution_id, user_id) do
    Request.id(:financialInstitutionId, institution_id)
    |> Request.id(:financialInstitutionUserId, user_id)
    |> list
  end
  def list(%Request{} = request) do
    request
    |> Request.id(:id, "")
    |> Client.execute(:get, @api_schema_path, __MODULE__)
  end

  def find(institution_id, user_id, account_id) do
    Request.id(:financialInstitutionId, institution_id)
    |> Request.id(:financialInstitutionUserId, user_id)
    |> Request.id(:id, account_id)
    |> find
  end
  def find(%Request{} = request) do
    request
    |> Client.execute(:get, @api_schema_path, __MODULE__)
  end

  def delete(institution_id, user_id, account_id) do
    Request.id(:financialInstitutionId, institution_id)
    |> Request.id(:financialInstitutionUserId, user_id)
    |> Request.id(:id, account_id)
    |> delete
  end
  def delete(%Request{} = request) do
    request
    |> Client.execute(:delete, @api_schema_path, __MODULE__)
  end

  def key_mapping do
    [
      id: ~w(id),
      available_balance: ~w(attributes availableBalance),
      currency: ~w(attributes currency),
      current_balance: ~w(attributes currentBalance),
      description: ~w(attributes description),
      reference: ~w(attributes reference),
      reference_type: ~w(attributes referenceType),
      subtype: ~w(attributes subtype),
      created_at: ~w(attributes createdAt),
      updated_at: ~w(attributes updatedAt)
    ]
  end
end
