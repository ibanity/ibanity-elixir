defmodule Ibanity.PontoConnect.PaymentRequest do
  @moduledoc """
  [Payment Request](https://documentation.ibanity.com/ponto-connect/api#payment-request) API wrapper
  """

  use Ibanity.Resource

  @api_schema_path ["ponto-connect", "account", "paymentRequests"]

  defstruct [
    :id,
    :currency,
    :amount,
    :end_to_end_id,
    :remittance_information,
    :remittance_information_type,
    :creditor_account_reference,
    :creditor_account_reference_type,
    :closed_at,
    :debtor_account_reference,
    :debtor_account_reference_type,
    :redirect_uri,
    :signed_at,
    :signing_uri
  ]

  alias Ibanity.PontoConnect

  @doc """
  [Creates a Payment Request](https://documentation.ibanity.com/ponto-connect/api#create-payment-request).

  Returns `{:ok, %__MODULE__{}}` if successful, `{:error, reason}` otherwise.

  ## Example

  #{PontoConnect.common_docs!(:account_id)}

  Attributes

      iex> attributes = [
      ...>   remittanceInformation: "payment-request",
      ...>   remittanceInformationType: "unstructured",
      ...>   amount: 0.5,
      ...>   endToEndId: "4874366da78549e0b3014a86cd646dc4",
      ...>   redirectUri: "https://fake-tpp.com/payment-request-confirmation?paymentRequest=123"
      ...> ]

  Use attributes and account_or_id:

      iex> PontoConnect.PaymentRequest.create(%Ibanity.PontoConnect.Token{}, account_or_id, attributes)
      {:ok, %PontoConnect.PaymentRequest{id: "343e64e5-4882-4559-96d0-221c398288f3"}}

      iex> request = Request.customer_access_token(%PontoConnect.Token{})
      iex> PontoConnect.PaymentRequest.create(request, account_or_id, attributes)
      {:ok, %PontoConnect.PaymentRequest{id: "343e64e5-4882-4559-96d0-221c398288f3"}}
  """
  def create(%PontoConnect.Token{} = token, account_or_id, attrs) do
    token
    |> Request.customer_access_token()
    |> create(account_or_id, attrs)
  end

  def create(%Request{} = request, %PontoConnect.Account{id: account_id}, attrs) do
    create(request, account_id, attrs)
  end

  def create(%Request{} = request, account_id, attrs)
      when is_bitstring(account_id) and is_list(attrs) do
    request
    |> Request.id(:account_id, account_id)
    |> Request.attributes(attrs)
    |> create()
  end

  @doc """
  Same as create/3, but `:attributes`, `:account_id`, and `:customer_access_token` must be set in request.

  ## Examples

  Set id and customer_access_token to create a PaymentRequest

      iex> %PontoConnect.Token{}
      ...> |> Request.customer_access_token()
      ...> |> Request.id(:account_id, account_id)
      ...> |> Request.attributes(attributes)
      ...> |> PontoConnect.PaymentRequest.create()
      {:ok, %PontoConnect.PaymentRequest{id: "343e64e5-4882-4559-96d0-221c398288f3"}}
  """
  def create(%Request{} = request) do
    request
    |> Request.id("")
    |> Client.execute(:post, @api_schema_path, __MODULE__)
  end

  @doc """
  [Find Payment Request by id](https://documentation.ibanity.com/ponto-connect/2/api#get-payment-request)

  Takes a `Ibanity.PontoConnect.Token`, or a `Ibanity.Request` with set `:customer_access_token` as first argument.

  #{PontoConnect.common_docs!(:account_and_id_second_arg)}

  ## Examples

  #{PontoConnect.common_docs!(:account_id)}

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.PontoConnect.PaymentRequest.find(%{
      ...>   account_id: account_or_id,
      ...>   id: "953934eb-229a-4fd2-8675-07794078cc7d"
      ...> })
      {:ok, %Ibanity.PontoConnect.PaymentRequest{id: "953934eb-229a-4fd2-8675-07794078cc7d"}}

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.Request.customer_access_token()
      ...> |> Ibanity.Request.application(:my_application)
      ...> |> Ibanity.PontoConnect.PaymentRequest.find(%{
      ...>   account_id: account_or_id,
      ...>   id: "953934eb-229a-4fd2-8675-07794078cc7d"
      ...> })
      {:ok, %Ibanity.PontoConnect.PaymentRequest{id: "953934eb-229a-4fd2-8675-07794078cc7d"}}

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.PontoConnect.PaymentRequest.find(%{account_id: account_or_id, id: "does-not-exist"})
      {:error,
        [
          %{
            "code" => "resourceNotFound",
            "detail" => "The requested resource was not found.",
            "meta" => %{
              "requestId" => "00077F00000184847F0000011F4066E44223327005A",
              "resource" => "paymentRequest"
            }
          }
        ]}
  """
  def find(%Request{} = request, %{account_id: account_id, id: id} = ids)
      when not is_nil(account_id) and not is_nil(id) do
    formatted_ids = PontoConnect.format_ids(ids)

    request
    |> Request.ids(formatted_ids)
    |> Client.execute(:get, @api_schema_path, __MODULE__)
  end

  def find(%PontoConnect.Token{} = token, ids) do
    token
    |> Request.customer_access_token()
    |> find(ids)
  end

  def find(other, _id) do
    raise ArgumentError,
      message: PontoConnect.token_argument_error_msg("PaymentRequest", other)
  end

  @doc """
  [Delete a Payment Request by id](https://documentation.ibanity.com/ponto-connect/2/api#delete-payment-request)

  #{PontoConnect.common_docs!(:account_and_id_second_arg)}

  ## Examples

  #{PontoConnect.common_docs!(:account_id)}

  Use `account_or_id` to delete a Payment Request:

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.PontoConnect.PaymentRequest.delete(%{
      ...>   id: "953934eb-229a-4fd2-8675-07794078cc7d", account_id: account_or_id
      ...> })
      {:ok, %Ibanity.PontoConnect.PaymentRequest{id: "953934eb-229a-4fd2-8675-07794078cc7d"}}

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.Request.customer_access_token()
      ...> |> Ibanity.Request.application(:my_application)
      ...> |> Ibanity.PontoConnect.PaymentRequest.delete(%{
      ...>   id: "953934eb-229a-4fd2-8675-07794078cc7d", account_id: account_or_id
      ...> })
      {:ok, %Ibanity.PontoConnect.PaymentRequest{id: "953934eb-229a-4fd2-8675-07794078cc7d"}}

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.PontoConnect.PaymentRequest.delete(%{
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
              "resource" => "paymentRequest"
            }
          }
        ]}
  """
  def delete(%Request{} = request_or_token, %{account_id: account_id} = ids)
      when not is_nil(account_id) do
    formatted_ids = PontoConnect.format_ids(ids)

    request_or_token
    |> Request.ids(formatted_ids)
    |> Client.execute(:delete, @api_schema_path, __MODULE__)
  end

  def delete(%PontoConnect.Token{} = request_or_token, ids) do
    request_or_token
    |> Request.customer_access_token()
    |> delete(ids)
  end

  def delete(other, _ids) do
    raise ArgumentError,
      message: PontoConnect.token_argument_error_msg("PaymentRequest", other)
  end

  @doc false
  def key_mapping do
    [
      id: {["id"], :string},
      currency: {["attributes", "currency"], :string},
      amount: {["attributes", "amount"], :number},
      end_to_end_id: {["attributes", "endToEndId"], :string},
      remittance_information: {["attributes", "remittanceInformation"], :string},
      remittance_information_type: {["attributes", "remittanceInformationType"], :string},
      creditor_account_reference: {["attributes", "creditorAccountReference"], :string},
      creditor_account_reference_type: {["attributes", "creditorAccountReferenceType"], :string},
      closed_at: {["attributes", "closedAt"], :map},
      debtor_account_reference: {["attributes", "debtorAccountReference"], :map},
      debtor_account_reference_type: {["attributes", "debtorAccountReferenceType"], :map},
      redirect_uri: {["attributes", "redirectUri"], :string},
      signed_at: {["attributes", "signedAt"], :map},
      signing_uri: {["attributes", "signingUri"], :string}
    ]
  end
end
