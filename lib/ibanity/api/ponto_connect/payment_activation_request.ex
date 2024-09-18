defmodule Ibanity.PontoConnect.PaymentActivationRequest do
  @moduledoc """
  [Payment Activation Request](https://documentation.ibanity.com/ponto-connect/api#payment-activation-request) API wrapper
  """

  use Ibanity.Resource

  @api_schema_path ["ponto-connect", "paymentActivationRequests"]

  defstruct [
    :id,
    :redirect
  ]

  alias Ibanity.PontoConnect

  @doc """
  [Creates a Payment Activation Request](https://documentation.ibanity.com/ponto-connect/api#request-payment-activation).

  Returns `{:ok, %__MODULE__{}}` if successful, `{:error, reason}` otherwise.

  ## Example

  Attributes

      iex> attributes = [redirect_uri: "https://fake-tpp.com/payment-activation-request-confirmation"]

  Use attributes:

      iex> Ibanity.PontoConnect.PaymentActivationRequest.create(token, attributes)
      {:ok, %Ibanity.PontoConnect.PaymentActivationRequest{id: "343e64e5-4882-4559-96d0-221c398288f3"}}

      iex> request = Request.customer_access_token(token)
      iex> Ibanity.PontoConnect.PaymentActivationRequest.create(request, attributes)
      {:ok, %Ibanity.PontoConnect.PaymentActivationRequest{id: "343e64e5-4882-4559-96d0-221c398288f3"}}
  """
  def create(%PontoConnect.Token{} = request_or_token, attrs) do
    request_or_token
    |> Request.customer_access_token()
    |> create(attrs)
  end

  def create(%Request{customer_access_token: token} = request_or_token, attrs)
      when not is_nil(token) and is_list(attrs) do
    request_or_token
    |> Request.attributes(attrs)
    |> create()
  end

  def create(other, _attrs) do
    raise ArgumentError,
      message:
        PontoConnect.RequestUtils.token_argument_error_msg("PaymentActivationRequest", other)
  end

  @doc """
  Same as `create/2`, but `:attributes`, `:account_id`, and `:customer_access_token` must be set in request.

  ## Examples

  Set id and customer_access_token to request a BulkPayment

      iex> %PontoConnect.Token{}
      ...> |> Request.customer_access_token()
      ...> |> Request.attributes(attributes)
      ...> |> PontoConnect.BulkPayment.create()
      {:ok, %PontoConnect.BulkPayment{id: "343e64e5-4882-4559-96d0-221c398288f3"}}
  """
  def create(%Request{} = request) do
    Client.execute(request, :post, @api_schema_path, __MODULE__)
  end

  @doc false
  def key_mapping do
    [
      id: {["id"], :string},
      redirect: {["links", "redirect"], :string}
    ]
  end
end
