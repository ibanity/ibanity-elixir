defmodule Ibanity.FinancialInstitution do
  alias Ibanity.{FinancialInstitution, Request, ResourceOperations}
  alias Ibanity.Client.Request, as: ClientRequest

  defstruct [
    id: nil,
    sandbox: true,
    name: nil,
    self_link: nil
  ]

  @type t :: %FinancialInstitution{id: String.t, sandbox: boolean, name: String.t, self_link: String.t}

  @resource_id_name :financialInstitutionId
  @resource_type "financialInstitution"

  @sandbox_api_schema_path ["sandbox", "financialInstitutions"]
  @find_api_schema_path    ["financialInstitutions"]

  def list, do: list(%Request{})
  def list(%Request{} = request) do
    {request, id_path} =
      if Request.has_customer_access_token?(request) do
        {request, ["customer", "financialInstitutions"]}
      else
        resource_ids = Keyword.put(request.resource_ids, :financialInstitutionId, "")
        {%Request{request | resource_ids: resource_ids}, ["financialInstitutions"]}
      end

    request
    |> ClientRequest.build(id_path, @resource_type)
    |> ResourceOperations.list(__MODULE__)
  end

  def find(id) when is_binary(id), do: find(%Request{resource_ids: [{@resource_id_name, id}]})
  def find(%Request{} = request) do
    request
    |> ClientRequest.build(@find_api_schema_path, @resource_type)
    |> ResourceOperations.find(__MODULE__)
  end

  def create(%Request{} = request) do
    request
    |> ClientRequest.build(@sandbox_api_schema_path, @resource_type)
    |> ResourceOperations.create(__MODULE__)
  end

  def update(%Request{} = request) do
    request
    |> ClientRequest.build(@sandbox_api_schema_path, @resource_type)
    |> ResourceOperations.update(__MODULE__)
  end

  def delete(id) when is_binary(id), do: delete(%Request{resource_ids: [{@resource_id_name, id}]})
  def delete(%Request{} = request) do
    request
    |> ClientRequest.build(@sandbox_api_schema_path, @resource_type)
    |> ResourceOperations.destroy(__MODULE__)
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
