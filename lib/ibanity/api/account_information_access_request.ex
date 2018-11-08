defmodule Ibanity.AccountInformationAccessRequest do
  @moduledoc """
  Account information access requests API wrapper
  """

  use Ibanity.Resource

  defstruct [
    id: nil,
    redirect_link: nil,
    requested_account_references: nil
  ]

  @api_schema_path  ["customer", "financialInstitution", "accountInformationAccessRequests"]

  def create(%Request{} = request) do
    request
    |> HttpRequest.build(:post, @api_schema_path, "accountInformationAccessRequest")
    |> Client.execute(__MODULE__)
  end

  def key_mapping do
    [
      id: ~w(id),
      redirect_link: ~w(links redirect),
      requested_account_references: ~w(attributes requestedAccountReferences)
    ]
  end
end
