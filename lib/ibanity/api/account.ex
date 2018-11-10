defmodule Ibanity.Account do
  @moduledoc """
  Acounts API wrapper
  """

  use Ibanity.Resource

  defstruct [
    id: nil,
    subtype: nil,
    reference_type: nil,
    reference: nil,
    description: nil,
    current_balance: nil,
    currency: nil,
    available_balance: nil,
    financial_institution: nil,
    transactions: nil
  ]

  def key_mapping do
    [
      id: ~w(id),
      subtype: ~w(attributes subtype),
      reference_type: ~w(attributes referenceType),
      reference: ~w(attributes reference),
      description: ~w(attributes description),
      current_balance: ~w(attributes currentBalance),
      currency: ~w(attributes currency),
      available_balance: ~w(attributes availableBalance),
      transactions: ~w(relationships transactions links related),
      financial_institution: ~w(relationships financialInstitution links related)
    ]
  end

  def list, do: list(%Request{})
  def list(financial_institution_id) when is_binary(financial_institution_id) do
    %Request{}
    |> Request.id(:financialInstitutionId, financial_institution_id)
    |> list
  end
  def list(%Request{} = request), do: list(request, Request.get_id(request, :financialInstitutionId))
  def list(%Request{} = request, nil) do
    request
    |> Request.id(:id, "")
    |> Client.execute(:get, ["customer", "accounts"], __MODULE__)
  end
  def list(%Request{} = request, financial_institution_id) do
    request
    |> Request.id(:id, "")
    |> Request.id(:financialInstitutionId, financial_institution_id)
    |> Client.execute(:get, ["customer", "financialInstitution", "accounts"], __MODULE__)
  end

  def find(%Request{} = request) do
    request
    |> Client.execute(:get, ["customer", "financialInstitution", "accounts"], __MODULE__)
  end
  def find(%Request{} = request, account_id, financial_institution_id) do
    request
    |> Request.id(:id, account_id)
    |> Request.id(:financialInstitutionId, financial_institution_id)
    |> find
  end

  def delete(account_id, financial_institution_id) do
    delete(%Request{}, account_id, financial_institution_id)
  end
  def delete(%Request{} = request, account_id, financial_institution_id) do
    request
    |> Request.id(:id, account_id)
    |> Request.id(:financialInstitutionId, financial_institution_id)
    |> delete
  end
  def delete(%Request{} = request) do
    request
    |> Client.execute(:delete, ["customer", "financialInstitution", "accounts"], __MODULE__)
  end
end
