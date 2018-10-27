defmodule Ibanity.FinancialInstitution do
  alias Ibanity.{Configuration, FinancialInstitution, Request, ResourceOperations}

  @base_keys [:sandbox, :name]
  defstruct id: nil, sandbox: true, name: nil, self_link: nil

  @type t :: %FinancialInstitution{id: String.t, sandbox: boolean, name: String.t, self_link: String.t}

  @spec list(String.t, map) :: [FinancialInstitution.t]
  def list(customer_access_token \\ nil, query_params \\ %{}) do
    schema  = Configuration.api_schema()
    id_path = if customer_access_token, do: ["customer", "financialInstitutions"], else: ["financialInstitutions"]

    request =
      schema
      |> get_in(id_path)
      |> String.replace("{financialInstitutionId}", "")
      |> Request.new
      |> Request.customer_access_token(customer_access_token)
      |> Request.build

    ResourceOperations.list_by_uri(__MODULE__, request)
  end

  def find(id) do
    schema  = Configuration.api_schema()

    request =
      schema
      |> Map.fetch!("financialInstitutions")
      |> String.replace("{financialInstitutionId}", id)
      |> Request.new
      |> Request.build

    ResourceOperations.find_by_uri(__MODULE__, request)
  end

  def create(%__MODULE__{} = institution, idempotency_key \\ nil) do
    schema  = Configuration.api_schema()

    attributes =
      institution
      |> Map.from_struct
      |> Map.take(@base_keys)

    request =
      schema
      |> get_in(["sandbox", "financialInstitutions"])
      |> String.replace("{financialInstitutionId}", "")
      |> Request.new
      |> Request.idempotency_key(idempotency_key)
      |> Request.resource_type("financialInstitution")
      |> Request.attributes(attributes)
      |> Request.build

    ResourceOperations.create_by_uri(__MODULE__, request)
  end

  # TODO: Discuss if it's better to use
  # update(%__MODULE__{} = institution, idempotency_key \\ nil)
  # or
  # update(id, %__MODULE__{} = institution, idempotency_key \\ nil)
  #
  def update(%__MODULE__{} = institution, idempotency_key \\ nil) do
    schema = Configuration.api_schema()

    attributes =
      institution
      |> Map.from_struct
      |> Map.take(@base_keys)

    request =
      schema
      |> get_in(["sandbox", "financialInstitutions"])
      |> String.replace("{financialInstitutionId}", institution.id)
      |> Request.new
      |> Request.idempotency_key(idempotency_key)
      |> Request.resource_type("financialInstitution")
      |> Request.attributes(attributes)
      |> Request.build

    ResourceOperations.update_by_uri(__MODULE__, request)
  end

  def delete(%__MODULE__{} = institution, idempotency_key \\ nil) do
    schema = Configuration.api_schema()

    attributes =
      institution
      |> Map.from_struct
      |> Map.take(@base_keys)

    request =
      schema
      |> get_in(["sandbox", "financialInstitutions"])
      |> String.replace("{financialInstitutionId}", institution.id)
      |> Request.new
      |> Request.idempotency_key(idempotency_key)
      |> Request.resource_type("financialInstitution")
      |> Request.attributes(attributes)
      |> Request.build

    ResourceOperations.destroy_by_uri(__MODULE__, request)
  end

  def keys, do: @base_keys
end
