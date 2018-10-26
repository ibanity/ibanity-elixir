defmodule Ibanity.FinancialInstitution do
  alias Ibanity.{Client, Collection, FinancialInstitution, ResourceOperations}

  @base_keys [:sandbox, :name]
  @enforce_keys [:id, :self_link | @base_keys]
  defstruct id: nil, sandbox: true, name: nil, self_link: nil

  @type t :: %FinancialInstitution{id: String.t, sandbox: boolean, name: String.t, self_link: String.t}

  @spec list(String.t, map) :: [FinancialInstitution.t]
  def list(customer_access_token \\ nil, query_params \\ %{}) do
    schema  = Client.api_schema()
    id_path = if customer_access_token, do: ["customer", "financialInstitutions"], else: ["financialInstitutions"]
    uri =
      schema
      |> get_in(id_path)
      |> String.replace("{financialInstitutionId}", "")

    ResourceOperations.list_by_uri(__MODULE__, uri, query_params, customer_access_token)
  end

  def keys, do: @base_keys
end