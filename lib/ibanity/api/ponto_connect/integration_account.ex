defmodule Ibanity.PontoConnect.IntegrationAccount do
  @moduledoc """
  [Integration Account](https://documentation.ibanity.com/ponto-connect/api#integration-account) API wrapper

  #{Ibanity.PontoConnect.CommonDocs.fetch!(:client_token)}
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
  [List Integration Accounts](https://documentation.ibanity.com/ponto-connect/2/api#list-integration-account)

  Takes a `Ibanity.PontoConnect.Token`, or a `Ibanity.Request` with set `:token` as argument.

  ## Examples

  With client token

      iex> Ibanity.PontoConnect.IntegrationAccount.list(client_token)
      {:ok, %Ibanity.Collection{
        items: [%Ibanity.PontoConnect.IntegrationAccount{}]
      }}

  With request

      iex> client_token |> Ibanity.Request.token() |> Ibanity.PontoConnect.IntegrationAccounts.list()
      {:ok, %Ibanity.Collection{
        items: [%Ibanity.PontoConnect.IntegrationAccount{}]
      }}

  Error

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
  def list(%Request{token: token} = request_or_token)
      when not is_nil(token) do
    Client.execute(request_or_token, :get, @api_schema_path, __MODULE__)
  end

  def list(%PontoConnect.Token{} = request_or_token) do
    request_or_token
    |> Request.token()
    |> list()
  end

  def list(other) do
    raise ArgumentError,
      message: PontoConnect.RequestUtils.token_argument_error_msg("Integration Accounts", other)
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
