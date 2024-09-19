defmodule Ibanity.PontoConnect.UserInfo do
  @moduledoc """
  [User Info](https://documentation.ibanity.com/ponto-connect/api#user-info) API wrapper
  """

  use Ibanity.Resource

  @api_schema_path ["ponto-connect", "userinfo"]

  defstruct [
    :name,
    :sub,
    :payments_activated,
    :payments_activation_requested,
    :payment_requests_activated,
    :payment_requestsActivation_requested,
    :onboarding_complete
  ]

  alias Ibanity.PontoConnect

  @doc """
  [Get User Info for access token](https://documentation.ibanity.com/ponto-connect/2/api#user-info-object)

  ## Examples

  Use a client token

      iex> Ibanity.PontoConnect.UserInfo.myself(client_token)
      {:ok, %Ibanity.PontoConnect.UserInfo{}}

  Or a request with client token set as `:token`

      iex> request = Ibanity.Request.token(client_token)
      iex> Ibanity.PontoConnect.UserInfo.myself(request)
      {:ok, %Ibanity.PontoConnect.UserInfo{}}
  """
  def myself(%PontoConnect.Token{} = request_or_token) do
    request_or_token
    |> Request.token()
    |> myself()
  end

  def myself(%Request{token: client_token} = request_or_token)
      when not is_nil(client_token) do
    request_or_token
    |> Client.execute(:get, @api_schema_path, __MODULE__)
  end

  def myself(other) do
    raise ArgumentError,
      message: PontoConnect.RequestUtils.token_argument_error_msg("UserInfo", other)
  end

  @doc false
  def key_mapping do
    [
      name: {["name"], :string},
      sub: {["sub"], :string},
      payments_activated: {["paymentsActivated"], :boolean},
      payments_activation_requested: {["paymentsActivationRequested"], :boolean},
      payment_requests_activated: {["paymentRequestsActivated"], :boolean},
      payment_requestsActivation_requested: {["paymentRequestsActivationRequested"], :boolean},
      onboarding_complete: {["onboardingComplete"], :boolean}
    ]
  end
end
