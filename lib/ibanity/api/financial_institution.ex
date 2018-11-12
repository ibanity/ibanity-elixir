defmodule Ibanity.FinancialInstitution do
  @moduledoc """
  Financial institutions API wrapper
  """

  use Ibanity.Resource

  defstruct [
    id: nil,
    sandbox: true,
    name: nil,
    self_link: nil
  ]

  @resource_id_name :financialInstitutionId
  @resource_type "financialInstitution"

  @sandbox_api_schema_path ["sandbox", "financialInstitutions"]
  @find_api_schema_path    ["financialInstitutions"]

  def list, do: list(%Request{})
  def list(%Request{customer_access_token: nil} = request) do
    request
    |> Request.id(:id, "")
    |> Client.execute(:get, ["financialInstitutions"])
  end
  def list(%Request{} = request) do
    request
    |> Client.execute(:get, ["customer", "financialInstitutions"])
  end

  def find(id) when is_binary(id), do: find(%Request{resource_ids: [{@resource_id_name, id}]})
  def find(%Request{} = request) do
    request
    |> Client.execute(:get, @find_api_schema_path)
  end

  def create(%Request{} = request) do
    request
    |> Request.id(:id, "")
    |> Request.resource_type(@resource_type)
    |> Client.execute(:post, @sandbox_api_schema_path)
  end

  def update(%Request{} = request) do
    request
    |> Request.resource_type(@resource_type)
    |> Client.execute(:patch, @sandbox_api_schema_path)
  end

  def delete(id) when is_binary(id), do: delete(%Request{resource_ids: [{@resource_id_name, id}]})
  def delete(%Request{} = request) do
    request
    |> Client.execute(:delete, @sandbox_api_schema_path)
  end

  def key_mapping do
    [
      id: ~w(id),
      sandbox: ~w(attributes sandbox),
      name: ~w(attributes name),
      self_link: ~w(links self)
    ]
  end
end
