defmodule Ibanity.PontoConnect.ReauthorizationRequest do
  @moduledoc """
  [Reauthorization API wrapper](https://documentation.ibanity.com/ponto-connect/2/api#reauthorization-request)
  """
  use Ibanity.Resource

  defstruct [:id, :redirect_uri]

  alias Ibanity.PontoConnect

  @api_schema_path ["ponto-connect", "account", "reauthorizationRequests"]

  @doc """
  [Requests an account reauthorization](https://documentation.ibanity.com/ponto-connect/api#request-account-reauthorization).

  Returns `{:ok, %__MODULE__{}}` if successful, `{:error, reason}` otherwise.

  ## Example

  #{PontoConnect.CommonDocs.fetch!(:account_id)}

      iex> PontoConnect.ReauthorizationRequest.create(%{
      ...>   account_id: account_or_id,
      ...>   redirect_uri: "https://fake-tpp.com/account-reauthorization-confirmation"
      ...> })
      {:ok, %PontoConnect.ReauthorizationRequest{
        redirect_uri: redirect_uri: "https://authorize.myponto.com/organizations/dd311734-9762-457e-989f-03292a1e55c9/sandbox/integrations/ad15e188-9385-44ef-a641-1cce3852c520/accounts/10cffaaf-f793-4672-bca1-4f150161b97e/reauthorization-requests/21bd0546-4ec2-4da3-8117-56b265255dec"
      }}

      iex> %PontoConnect.Token{}
      ...> |> PontoConnect.ReauthorizationRequest.create(attributes)
  """
  def create(%PontoConnect.Token{} = token, attrs) do
    token
    |> Request.customer_access_token()
    |> create(attrs)
  end

  def create(%Request{} = request, %{account_id: %PontoConnect.Account{id: account_id}} = attrs) do
    updated_attrs = Map.put(attrs, :account_id, account_id)
    create(request, updated_attrs)
  end

  def create(%Request{} = request, %{account_id: account_id, redirect_uri: redirect_uri}) do
    request
    |> Request.id(:account_id, account_id)
    |> Request.attribute(:redirect_uri, redirect_uri)
    |> create()
  end

  @doc """
  Same as create/2, but `:attributes` and `:customer_access_token` must be set in request.

  ## Examples

  Set id and customer_access_token to request a reauthorization

      iex> %PontoConnect.Token{}
      ...> |> Request.customer_access_token()
      ...> |> Request.id(:account_id, account_id)
      ...> |> Request.attribute(:redirect_uri, "https://fake-tpp.com/account-reauthorization-confirmation")
      ...> |> PontoConnect.Reauthorization.create()
      {:ok, %PontoConnect.Reauthorization{
        redirect_uri: "https://authorize.myponto.com/organizations/dd311734-9762-457e-989f-03292a1e55c9/sandbox/integrations/ad15e188-9385-44ef-a641-1cce3852c520/accounts/10cffaaf-f793-4672-bca1-4f150161b97e/reauthorization-requests/21bd0546-4ec2-4da3-8117-56b265255dec"
      }}
  """
  def create(%Request{} = request),
    do: Client.execute(request, :post, @api_schema_path, __MODULE__)

  @doc false
  def key_mapping do
    [
      redirect_uri: {["links", "redirect"], :string},
      id: {["id"], :string}
    ]
  end
end
