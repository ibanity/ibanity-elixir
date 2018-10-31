defmodule Ibanity.AccountInformationAccessRequest do
  alias Ibanity.{Configuration, Request, ResourceIdentifier, ResourceOperations}
  alias Ibanity.Client.Request, as: ClientRequest

  defstruct [
    id: nil,
    redirect_link: nil,
    requested_account_references: nil
  ]

  @resource_id_name :financialInstitution

  def create(%Request{} = request) do
    with {:ok, id}      <- validate_id(request),
         uri            <- generate_uri(id),
         client_request <- ClientRequest.build(request, uri, "accountInformationAccessRequest")
    do
      ResourceOperations.create(client_request, __MODULE__)
    else
      error -> error
    end
  end

  defp generate_uri(id) do
    Configuration.api_schema
    |> get_in(["customer", "financialInstitution", "accountInformationAccessRequests"])
    |> String.replace("{financialInstitutionId}", id)
    |> String.replace("{accountInformationAccessRequestId}", "")
  end

  defp validate_id(%Request{} = request) do
    case ResourceIdentifier.validate_ids([@resource_id_name], request.resource_ids) do
      {:ok, ids} -> {:ok, ids |> List.first |> elem(1)}
      error      -> error
    end
  end

  def key_mapping do
    [
      id: ~w(id),
      redirect_link: ~w(links redirect),
      requested_account_references: ~w(attributes requestedAccountReferences)
    ]
  end
end
