defmodule Ibanity.PontoConnect.IntegrationAccount do
  @moduledoc """
  [Integration Account](https://documentation.ibanity.com/ponto-connect/api#integration-account) API wrapper

  #{Ibanity.PontoConnect.common_docs!(:client_token)}
  """

  use Ibanity.Resource

  @api_schema_path ["ponto-connect", "integrationAccounts"]

  defstruct [
    :id,
    :created_at,
    :last_accessed_at,
    :organization_id,
    :financial_institution_id,
    :account_id
  ]

  alias Ibanity.PontoConnect

  @doc """
  [List Integration Accounts](https://documentation.ibanity.com/ponto-connect/2/api#list-integration-accounts)

  Takes a `Ibanity.PontoConnect.Token`, or a `Ibanity.Request` with set `:customer_access_token` as argument.

  ## Examples

      iex> Ibanity.PontoConnect.IntegrationAccount.list(client_token)
      {:ok, %Ibanity.Collection{
        items: [%Ibanity.PontoConnect.IntegrationAccount{}]
      }}

      iex> client_token |> Ibanity.Request.customer_access_token() |> Ibanity.PontoConnect.IntegrationAccounts.list()
      {:ok, %Ibanity.Collection{
        items: [%Ibanity.PontoConnect.IntegrationAccount{}]
      }}

      iex> invalid_token |> Ibanity.PontoConnect.IntegrationAccount.list()
      {:error,
        [
          %{
            "code" => "invalidAccessToken",
            "detail" => "Your access token is invalid.",
            "meta" => %{"requestId" => "00077F000001D3A87F0000011F4066E43AFD1900051"}
          }
        ]}

  """
  def list(%Request{customer_access_token: customer_access_token} = request)
      when not is_nil(customer_access_token) do
    Client.execute(request, :get, @api_schema_path, __MODULE__)
  end

  def list(%PontoConnect.Token{} = token) do
    token
    |> Request.customer_access_token()
    |> list()
  end

  def list(other) do
    raise ArgumentError,
      message: PontoConnect.token_argument_error_msg("Accounts", other)
  end

  @doc false
  def key_mapping do
    [
      id: {["id"], :string},
      created_at: {["attributes", "createdAt"], :datetime},
      last_accessed_at: {["attributes", "lastAccessedAt"], :datetime},
      organization_id: {["relationships", "organization", "data", "id"], :string},
      financial_institution_id:
        {["relationships", "financialInstitution", "data", "id"], :string},
      account_id: {["relationships", "account", "data", "id"], :string}
    ]
  end
end
