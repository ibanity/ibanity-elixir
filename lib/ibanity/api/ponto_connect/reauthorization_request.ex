defmodule Ibanity.PontoConnect.ReauthorizationRequest do
  @moduledoc """
  [Reauthorization API wrapper](https://documentation.ibanity.com/ponto-connect/2/api#reauthorization-request)
  """
  use Ibanity.Resource

  defstruct [:id, :redirect]

  alias Ibanity.PontoConnect

  @api_schema_path ["ponto-connect", "account", "reauthorizationRequests"]

  @doc """
  [Requests an account reauthorization](https://documentation.ibanity.com/ponto-connect/api#request-account-reauthorization).

  Returns `{:ok, %__MODULE__{}}` if successful, `{:error, reason}` otherwise.

  ## Example

  #{PontoConnect.CommonDocs.fetch!(:account_id)}

  Attributes

      iex> attributes = [redirect_uri: "https://fake-tpp.com/account-reauthorization-confirmation]

  With token

      iex> Ibanity.PontoConnect.ReauthorizationRequest.create(token, account_or_id, attributes)
      {:ok, %Ibanity.PontoConnect.ReauthorizationRequest{
        redirect: "https://authorize.myponto.com/organizations/dd311734-9762-457e-989f-03292a1e55c9/sandbox/integrations/ad15e188-9385-44ef-a641-1cce3852c520/accounts/10cffaaf-f793-4672-bca1-4f150161b97e/reauthorization-requests/21bd0546-4ec2-4da3-8117-56b265255dec"
      }}

  With request

      iex> token
      ...> Ibanity.Request.token()
      ...> |> Ibanity.PontoConnect.ReauthorizationRequest.create(account_or_id, attributes)
      {:ok, %Ibanity.PontoConnect.ReauthorizationRequest{
        redirect: "https://authorize.myponto.com/organizations/dd311734-9762-457e-989f-03292a1e55c9/sandbox/integrations/ad15e188-9385-44ef-a641-1cce3852c520/accounts/10cffaaf-f793-4672-bca1-4f150161b97e/reauthorization-requests/21bd0546-4ec2-4da3-8117-56b265255dec"
      }}
  """
  def create(%PontoConnect.Token{} = request_or_token, account_or_id, attrs) do
    request_or_token
    |> Request.token()
    |> create(account_or_id, attrs)
  end

  def create(%Request{token: token} = request_or_token, account_or_id, attrs)
      when not is_nil(token) do
    formatted_ids = PontoConnect.RequestUtils.format_ids(%{account_id: account_or_id})

    request_or_token
    |> Request.ids(formatted_ids)
    |> Request.attributes(attrs)
    |> create()
  end

  def create(other, _account_or_id, _attrs) do
    raise ArgumentError,
      message: PontoConnect.Exceptions.token_argument_error_msg("ReauthorizationRequest", other)
  end

  @doc """
  Same as create/2, but `:attributes` and `:token` must be set in request.

  ## Examples

  Set id and token to request a reauthorization

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.Request.token()
      ...> |> Ibanity.Request.id(:account_id, account_id)
      ...> |> Ibanity.Request.attribute(:redirect_uri, "https://fake-tpp.com/account-reauthorization-confirmation")
      ...> |> Ibanity.PontoConnect.Reauthorization.create()
      {:ok, %Ibanity.PontoConnect.Reauthorization{
        redirect: "https://authorize.myponto.com/organizations/dd311734-9762-457e-989f-03292a1e55c9/sandbox/integrations/ad15e188-9385-44ef-a641-1cce3852c520/accounts/10cffaaf-f793-4672-bca1-4f150161b97e/reauthorization-requests/21bd0546-4ec2-4da3-8117-56b265255dec"
      }}
  """
  def create(%Request{} = request),
    do: Client.execute(request, :post, @api_schema_path, __MODULE__)

  @doc false
  def key_mapping do
    [
      redirect: {["links", "redirect"], :string},
      id: {["id"], :string}
    ]
  end
end
