defmodule Ibanity.PontoConnect.PaymentRequestActivationRequest do
  @moduledoc """
  [Payment Request Activation Request](https://documentation.ibanity.com/ponto-connect/api#payment-request-activation-request) API wrapper
  """

  use Ibanity.Resource

  @api_schema_path ["ponto-connect", "paymentRequestActivationRequests"]

  defstruct [
    :id,
    :redirect
  ]

  alias Ibanity.PontoConnect

  @doc """
  [Creates a Payment Request Activation Request](https://documentation.ibanity.com/ponto-connect/api#request-payment-request-activation).

  Returns `{:ok, %__MODULE__{}}` if successful, `{:error, reason}` otherwise.

  ## Examples

  Attributes

      iex> attributes = [redirect_uri: "https://fake-tpp.com/payment-request-activation-request-confirmation"]

  With token

      iex> Ibanity.PontoConnect.PaymentRequestActivationRequest.create(token, attributes)
      {:ok, %Ibanity.PontoConnect.PaymentRequestActivationRequest{id: "343e64e5-4882-4559-96d0-221c398288f3"}}

  With request

      iex> request = Ibanity.Request.token(token)
      iex> Ibanity.PontoConnect.PaymentRequestActivationRequest.create(request, attributes)
      {:ok, %Ibanity.PontoConnect.PaymentRequestActivationRequest{id: "343e64e5-4882-4559-96d0-221c398288f3"}}
  """
  def create(%PontoConnect.Token{} = request_or_token, attrs) do
    request_or_token
    |> Request.token()
    |> create(attrs)
  end

  def create(%Request{token: token} = request_or_token, attrs)
      when not is_nil(token) and is_list(attrs) do
    request_or_token
    |> Request.attributes(attrs)
    |> create()
  end

  def create(other, _attrs) do
    raise ArgumentError,
      message: PontoConnect.Exceptions.token_argument_error_msg("PaymentRequestActivationRequest", other)
  end

  @doc """
  Same as `create/2`, but `:attributes` and `:token` must be set in request.

  ## Examples

  Set id and token to create a PaymentRequestActivationRequest

      iex> token
      ...> |> Request.token()
      ...> |> Request.attributes(attributes)
      ...> |> PontoConnect.PaymentRequestActivationRequest.create()
      {:ok, %PontoConnect.PaymentRequestActivationRequest{id: "343e64e5-4882-4559-96d0-221c398288f3"}}
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
