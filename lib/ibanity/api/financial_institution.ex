defmodule Ibanity.FinancialInstitution do
  alias Ibanity.{Configuration, FinancialInstitution, Request, ResourceIdentifier, ResourceOperations}
  alias Ibanity.Client.Request, as: ClientRequest

  @base_keys [:sandbox, :name]
  defstruct id: nil, sandbox: true, name: nil, self_link: nil

  @type t :: %FinancialInstitution{id: String.t, sandbox: boolean, name: String.t, self_link: String.t}

  @resource_id_name :financialInstitution

  def list, do: list(%Request{})
  def list(%Request{} = request) do
    id_path =
      if Request.has_header?(request, :"Authorization") do
        ["customer", "financialInstitutions"]
      else
        ["financialInstitutions"]
      end

    uri = generate_uri(id_path)

    request
    |> generate_client_request(uri)
    |> ResourceOperations.list_by_uri(__MODULE__)
  end

  def find(id) when is_binary(id), do: find(%Request{resource_ids: [{@resource_id_name, id}]})
  def find(%Request{} = request) do
    id  = validate_id(request)
    uri = generate_uri(["financialInstitutions"], id)

    request
    |> generate_client_request(uri)
    |> ResourceOperations.find_by_uri(__MODULE__)
  end

  def create(%Request{} = request) do
    uri = generate_uri(["sandbox", "financialInstitutions"])

    request
    |> generate_client_request(uri)
    |> ResourceOperations.create_by_uri(__MODULE__)
  end

  def update(%Request{} = request) do
    id  = validate_id(request)
    uri = generate_uri(["sandbox", "financialInstitutions"], id)

    request
    |> generate_client_request(uri)
    |> ResourceOperations.update_by_uri(__MODULE__)
  end

  def delete(id) when is_binary(id), do: delete(%Request{resource_ids: [{@resource_id_name, id}]})
  def delete(%Request{} = request) do
    id  = validate_id(request)
    uri = generate_uri(["sandbox", "financialInstitutions"], id)

    request
    |> generate_client_request(uri)
    |> ResourceOperations.destroy_by_uri(__MODULE__)
  end

  defp generate_uri(path, replacement \\ "") do
    Configuration
    |> apply(:api_schema, [])
    |> get_in(path)
    |> String.replace("{financialInstitutionId}", replacement)
  end

  defp generate_client_request(%Request{} = request, uri) do
    request
    |> ClientRequest.build
    |> ClientRequest.uri(uri)
    |> ClientRequest.resource_type("financialInstitution")
  end

  def keys, do: @base_keys

  defp validate_id(%Request{} = request) do
    [@resource_id_name]
    |> ResourceIdentifier.validate_ids!(request.resource_ids)
    |> List.first
    |> elem(1)
  end
end
