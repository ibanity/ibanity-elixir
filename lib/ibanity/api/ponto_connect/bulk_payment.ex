defmodule Ibanity.PontoConnect.BulkPayment do
  @moduledoc """
  [Bulk Payment](https://documentation.ibanity.com/ponto-connect/api#bulk-payment) API wrapper
  """

  use Ibanity.Resource

  @api_schema_path ["ponto-connect", "account", "bulkPayments"]

  defstruct [
    :id,
    :status,
    :reference,
    :requested_execution_date,
    :batch_booking_preferred,
    :redirect
  ]

  alias Ibanity.PontoConnect

  @doc """
  [Creates a bulk payment](https://documentation.ibanity.com/ponto-connect/api#create-bulk-payment).

  Returns `{:ok, %__MODULE__{}}` if successful, `{:error, reason}` otherwise.

  ## Example

  #{PontoConnect.CommonDocs.fetch!(:account_id)}

  Attributes

      iex> attributes = [
      ...>  reference: "Invoice Payments",
      ...>  redirect_uri: "https://fake-tpp.com/payment-confirmation?payment=123",
      ...>  requested_execution_date: "2025-05-05",
      ...>  batch_booking_preferred: true,
      ...>  payments: [
      ...>    %{
      ...>      remittance_information: "payment 1",
      ...>      remittance_information_type: "unstructured",
      ...>      currency: "EUR",
      ...>      amount: 59,
      ...>      creditor_name: "Alex Creditor",
      ...>      creditor_account_reference: "BE55732022998044",
      ...>      creditor_account_reference_type: "IBAN",
      ...>      creditor_agent: "NBBEBEBB203",
      ...>      creditor_agent_type: "BIC",
      ...>      end_to_end_id: "1234567890"
      ...>    },
      ...>    %{
      ...>      remittance_information: "payment 2",
      ...>      remittance_information_type: "unstructured",
      ...>      currency: "EUR",
      ...>      amount: 25,
      ...>      creditor_name: "Pat Smith",
      ...>      creditor_account_reference: "BE73055155935764",
      ...>      creditor_account_reference_type: "IBAN",
      ...>      creditor_agent: "NBBEBEBB203",
      ...>      creditor_agent_type: "BIC",
      ...>      end_to_end_id: "0987654321"
      ...>    }
      ...>  ]
      ...> ]

  With token

      iex> Ibanity.PontoConnect.BulkPayment.create(%Ibanity.PontoConnect.Token{}, account_or_id, attributes)
      {:ok, %Ibanity.PontoConnect.BulkPayment{id: "343e64e5-4882-4559-96d0-221c398288f3"}}

  With request

      iex> request = Ibanity.Request.token(%PontoConnect.Token{})
      iex> Ibanity.PontoConnect.BulkPayment.create(request, account_or_id, attributes)
      {:ok, %Ibanity.PontoConnect.BulkPayment{id: "343e64e5-4882-4559-96d0-221c398288f3"}}
  """
  def create(%PontoConnect.Token{} = request_or_token, account_or_id, attrs) do
    request_or_token
    |> Request.token()
    |> create(account_or_id, attrs)
  end

  def create(%Request{} = request_or_token, %PontoConnect.Account{id: account_id}, attrs) do
    create(request_or_token, account_id, attrs)
  end

  def create(%Request{} = request_or_token, account_id, attrs)
      when is_bitstring(account_id) and is_list(attrs) do
    request_or_token
    |> Request.id(:account_id, account_id)
    |> Request.attributes(attrs)
    |> create()
  end

  def create(other, _account_id, _attrs) do
    raise ArgumentError,
      message: PontoConnect.Exceptions.token_argument_error_msg("BulkPayment", other)
  end

  @doc """
  Same as `create/3`, but `:attributes`, `:account_id`, and `:token` must be set in request.

  ## Examples

  Set id and token to request a BulkPayment

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.Request.token()
      ...> |> Ibanity.Request.id(:account_id, account_id)
      ...> |> Ibanity.Request.attributes(attributes)
      ...> |> Ibanity.PontoConnect.BulkPayment.create()
      {:ok, %Ibanity.PontoConnect.BulkPayment{id: "343e64e5-4882-4559-96d0-221c398288f3"}}
  """
  def create(%Request{} = request) do
    request
    |> Request.id("")
    |> Client.execute(:post, @api_schema_path, __MODULE__)
  end

  @doc """
  [Find Bulk Payment by id](https://documentation.ibanity.com/ponto-connect/2/api#get-payment)

  Takes a `Ibanity.PontoConnect.Token`, or a `Ibanity.Request` with set `:token` as first argument.

  #{PontoConnect.CommonDocs.fetch!(:account_and_id_second_arg)}

  ## Examples

  #{PontoConnect.CommonDocs.fetch!(:account_id)}

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.PontoConnect.BulkPayment.find(%{account_id: account_or_id, id: "d0e23b50-e150-403b-aa50-581a2329b5f5"})
      {:ok, %Ibanity.PontoConnect.BulkPayment{id: "d0e23b50-e150-403b-aa50-581a2329b5f5"}}

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.Request.token()
      ...> |> Ibanity.Request.application(:my_application)
      ...> |> Ibanity.PontoConnect.BulkPayment.find(%{account_id: account_or_id, id: "d0e23b50-e150-403b-aa50-581a2329b5f5"})
      {:ok, %Ibanity.PontoConnect.BulkPayment{id: "d0e23b50-e150-403b-aa50-581a2329b5f5"}}

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.PontoConnect.BulkPayment.find(%{account_id: account_or_id, id: "does-not-exist"})
      {:error,
        [
          %{
            "code" => "resourceNotFound",
            "detail" => "The requested resource was not found.",
            "meta" => %{
              "requestId" => "00077F00000184847F0000011F4066E44223327005A",
              "resource" => "bulkPayment"
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
      message: PontoConnect.Exceptions.token_argument_error_msg("BulkPayment", other)
  end

  @doc """
  [Delete a Bulk Payment by id](https://documentation.ibanity.com/ponto-connect/2/api#delete-bulk-payment)

  #{PontoConnect.CommonDocs.fetch!(:account_and_id_second_arg)}

  ## Examples

  #{PontoConnect.CommonDocs.fetch!(:account_id)}

  With token

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.PontoConnect.BulkPayment.delete(%{
      ...>   id: "953934eb-229a-4fd2-8675-07794078cc7d", account_id: account_or_id
      ...> })
      {:ok, %Ibanity.PontoConnect.BulkPayment{id: "953934eb-229a-4fd2-8675-07794078cc7d"}}

  With request

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.Request.token()
      ...> |> Ibanity.Request.application(:my_application)
      ...> |> Ibanity.PontoConnect.BulkPayment.delete(%{
      ...>   id: "953934eb-229a-4fd2-8675-07794078cc7d", account_id: account_or_id
      ...> })
      {:ok, %Ibanity.PontoConnect.BulkPayment{id: "953934eb-229a-4fd2-8675-07794078cc7d"}}

  Error

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.PontoConnect.BulkPayment.delete(%{
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
              "resource" => "bulkPayment"
            }
          }
        ]}
  """
  def delete(%Request{} = request_or_token, %{account_id: account_id} = ids)
      when not is_nil(account_id) do
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
      message: PontoConnect.Exceptions.token_argument_error_msg("BulkPayment", other)
  end

  @doc false
  def key_mapping do
    [
      id: {["id"], :string},
      status: {["attributes", "status"], :string},
      reference: {["attributes", "reference"], :string},
      requested_execution_date: {["attributes", "requestedExecutionDate"], :date},
      batch_booking_preferred: {["attributes", "batchBookingPreferred"], :boolean},
      redirect: {["links", "redirect"], :string}
    ]
  end
end
