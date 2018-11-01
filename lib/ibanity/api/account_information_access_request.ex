defmodule Ibanity.AccountInformationAccessRequest do
  alias Ibanity.{Request, ResourceOperations}
  alias Ibanity.Client.Request, as: ClientRequest

  defstruct [
    id: nil,
    redirect_link: nil,
    requested_account_references: nil
  ]

  @api_schema_path  ["customer", "financialInstitution", "accountInformationAccessRequests"]

  def create(%Request{} = request) do
    request
    |> ClientRequest.build(@api_schema_path, "accountInformationAccessRequest")
    |> ResourceOperations.create(__MODULE__)
  end

  def key_mapping do
    [
      id: ~w(id),
      redirect_link: ~w(links redirect),
      requested_account_references: ~w(attributes requestedAccountReferences)
    ]
  end
end
