defmodule Ibanity.PontoConnect.Payment do
  @moduledoc """
  [Payment](https://documentation.ibanity.com/ponto-connect/api#payment) API wrapper
  """

  use Ibanity.Resource

  @api_schema_path ["ponto-connect", "account", "payments"]

  defstruct [
    :id,
    :status,
    :currency,
    :amount,
    :end_to_end_id,
    :remittance_information,
    :remittance_information_type,
    :creditor_account_reference,
    :creditor_account_reference_type,
    :creditor_agent,
    :creditor_agent_type,
    :creditor_name,
    :requested_execution_date,
    :redirect
  ]

  alias Ibanity.PontoConnect

  @doc """
  [Creates a payment](https://documentation.ibanity.com/ponto-connect/api#create-payment).

  Returns `{:ok, %__MODULE__{}}` if successful, `{:error, reason}` otherwise.

  ## Examples

  #{PontoConnect.CommonDocs.fetch!(:account_id)}

  Attributes

      iex> attributes = [
      ...>   remittance_information: "payment",
      ...>   remittance_information_type: "unstructured",
      ...>   requested_execution_date: "2025-05-05",
      ...>   currency: "EUR",
      ...>   amount: 59,
      ...>   creditor_name: "Alex Creditor",
      ...>   creditor_account_reference: "BE55732022998044",
      ...>   creditor_account_reference_type: "IBAN",
      ...>   creditor_agent: "NBBEBEBB203",
      ...>   creditor_agent_type: "BIC",
      ...>   redirect_uri: "https://fake-tpp.com/payment-confirmation?payment=123",
      ...>   end_to_end_id: "1234567890"
      ...> ]

  Use attributes and account_or_id:

      iex> Ibanity.PontoConnect.Payment.create(token, account_or_id, attributes)
      {:ok, %Ibanity.PontoConnect.Payment{id: "343e64e5-4882-4559-96d0-221c398288f3"}}

  With request

      iex> request = Ibanity.Request.token(token)
      iex> Ibanity.PontoConnect.Payment.create(request, account_or_id, attributes)
      {:ok, %Ibanity.PontoConnect.Payment{id: "343e64e5-4882-4559-96d0-221c398288f3"}}
  """
  def create(%PontoConnect.Token{} = request_or_token, account_or_id, attrs) do
    request_or_token
    |> Request.token()
    |> create(account_or_id, attrs)
  end

  def create(%Request{token: token} = request_or_token, account_or_id, attrs)
      when not is_nil(token) and is_list(attrs) do
    formatted_ids = PontoConnect.RequestUtils.format_ids(%{account_id: account_or_id})

    request_or_token
    |> Request.ids(formatted_ids)
    |> Request.attributes(attrs)
    |> create()
  end

  def create(other, _account_or_id, _attrs) do
    raise ArgumentError,
      message: PontoConnect.RequestUtils.token_argument_error_msg("Payment", other)
  end

  @doc """
  Same as create/3, but `:attributes`, `:account_id`, and `:token` must be set in request.

  ## Examples

  Set id and token to request a Payment

      iex> %PontoConnect.Token{}
      ...> |> Request.token()
      ...> |> Request.id(:account_id, account_id)
      ...> |> Request.attributes(attributes)
      ...> |> PontoConnect.Payment.create()
      {:ok, %PontoConnect.Payment{id: "343e64e5-4882-4559-96d0-221c398288f3"}}
  """
  def create(%Request{} = request) do
    request
    |> Request.id("")
    |> Client.execute(:post, @api_schema_path, __MODULE__)
  end

  @doc """
  [Find Payment by id](https://documentation.ibanity.com/ponto-connect/2/api#get-payment)

  Takes a `Ibanity.PontoConnect.Token`, or a `Ibanity.Request` with set `:token` as first argument.

  #{PontoConnect.CommonDocs.fetch!(:account_and_id_second_arg)}

  ## Examples

  #{PontoConnect.CommonDocs.fetch!(:account_id)}

  IDs

      iex> ids = %{
      ...>   account_id: account_or_id,
      ...>   id: "953934eb-229a-4fd2-8675-07794078cc7d"
      ...> }

  With token

      iex> Ibanity.PontoConnect.Payment.find(token, ids)
      {:ok, %Ibanity.PontoConnect.Payment{id: "953934eb-229a-4fd2-8675-07794078cc7d"}}

  With request

      iex> token
      ...> |> Ibanity.Request.token()
      ...> |> Ibanity.Request.application(:my_application)
      ...> |> Ibanity.PontoConnect.Payment.find(ids)
      {:ok, %Ibanity.PontoConnect.Payment{id: "953934eb-229a-4fd2-8675-07794078cc7d"}}

      iex> Ibanity.PontoConnect.Payment.find(token, %{account_id: account_or_id, id: "does-not-exist"})
      {:error,
        [
          %{
            "code" => "resourceNotFound",
            "detail" => "The requested resource was not found.",
            "meta" => %{
              "requestId" => "00077F00000184847F0000011F4066E44223327005A",
              "resource" => "payment"
            }
          }
        ]}
  """
  def find(%Request{token: token} = request_or_token, ids)
      when not is_nil(token) do
    formatted_ids = PontoConnect.RequestUtils.format_ids(ids)

    request_or_token
    |> Request.ids(formatted_ids)
    |> Client.execute(:get, @api_schema_path, __MODULE__)
  end

  def find(%PontoConnect.Token{} = request_or_token, ids) do
    request_or_token
    |> Request.token()
    |> find(ids)
  end

  def find(other, _ids) do
    raise ArgumentError,
      message: PontoConnect.RequestUtils.token_argument_error_msg("Payment", other)
  end

  @doc """
  [Delete a Payment by id](https://documentation.ibanity.com/ponto-connect/2/api#delete-payment)

  #{PontoConnect.CommonDocs.fetch!(:account_and_id_second_arg)}

  ## Examples

  #{PontoConnect.CommonDocs.fetch!(:account_id)}

  IDs

      iex> ids = %{
      ...>   account_id: account_or_id,
      ...>   id: "953934eb-229a-4fd2-8675-07794078cc7d"
      ...> }

  With token

      iex> Ibanity.PontoConnect.Payment.delete(token, ids)
      {:ok, %Ibanity.PontoConnect.Payment{id: "953934eb-229a-4fd2-8675-07794078cc7d"}}

  With request

      iex> token
      ...> |> Ibanity.Request.token()
      ...> |> Ibanity.Request.application(:my_application)
      ...> |> Ibanity.PontoConnect.Payment.delete(ids)
      {:ok, %Ibanity.PontoConnect.Payment{id: "953934eb-229a-4fd2-8675-07794078cc7d"}}

  Error

      iex> Ibanity.PontoConnect.Payment.delete(token, %{
      ...>   id: "does-not-exist",
      ...>   account_id: account_or_id
      ...> })
      {:error,
        [
          %{
            "code" => "resourceNotFound",
            "detail" => "The requested resource was not found.",
            "meta" => %{
              "requestId" => "00077F00000184847F0000011F4066E44223327005A",
              "resource" => "payment"
            }
          }
        ]}
  """
  def delete(%Request{token: token} = request_or_token, ids)
      when not is_nil(token) do
    formatted_ids = PontoConnect.RequestUtils.format_ids(ids)

    request_or_token
    |> Request.ids(formatted_ids)
    |> Client.execute(:delete, @api_schema_path, __MODULE__)
  end

  def delete(%PontoConnect.Token{} = request_or_token, ids) do
    request_or_token
    |> Request.token()
    |> delete(ids)
  end

  def delete(other, _ids) do
    raise ArgumentError,
      message: PontoConnect.RequestUtils.token_argument_error_msg("Payment", other)
  end

  @doc false
  def key_mapping do
    [
      id: {["id"], :string},
      status: {["attributes", "status"], :string},
      currency: {["attributes", "currency"], :string},
      amount: {["attributes", "amount"], :number},
      end_to_end_id: {["attributes", "endToEndId"], :string},
      remittance_information: {["attributes", "remittanceInformation"], :string},
      remittance_information_type: {["attributes", "remittanceInformationType"], :string},
      creditor_account_reference: {["attributes", "creditorAccountReference"], :string},
      creditor_account_reference_type: {["attributes", "creditorAccountReferenceType"], :string},
      creditor_agent: {["attributes", "creditorAgent"], :string},
      creditor_agent_type: {["attributes", "creditorAgentType"], :string},
      creditor_name: {["attributes", "creditorName"], :string},
      requested_execution_date: {["attributes", "requestedExecutionDate"], :date},
      redirect: {["links", "redirect"], :string}
    ]
  end
end
