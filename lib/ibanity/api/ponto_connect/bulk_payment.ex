defmodule Ibanity.PontoConnect.BulkPayment do
  @moduledoc """
  [Bulk Payment](https://documentation.ibanity.com/xs2a/api#bulk-payment) API wrapper
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

  #{PontoConnect.common_docs!(:account_id)}

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

  Use attribues and account_or_id:

      iex> PontoConnect.Payment.create(%Ibanity.PontoConnect.Token{}, account_or_id, attributes)
      {:ok, %PontoConnect.PaymentRequest{id: "343e64e5-4882-4559-96d0-221c398288f3"}}

      iex> request = Request.customer_access_token(%PontoConnect.Token{})
      iex> PontoConnect.Payment.create(request, account_or_id, attributes)
      {:ok, %PontoConnect.PaymentRequest{id: "343e64e5-4882-4559-96d0-221c398288f3"}}
  """
  def create(%PontoConnect.Token{} = request_or_token, account_or_id, attrs) do
    request_or_token
    |> Request.customer_access_token()
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

  @doc """
  Same as create/3, but `:attributes`, `:account_id`, and `:customer_access_token` must be set in request.

  ## Examples

  Set id and customer_access_token to request a BulkPayment

      iex> %PontoConnect.Token{}
      ...> |> Request.customer_access_token()
      ...> |> Request.id(:account_id, account_id)
      ...> |> Request.attributes(attributes)
      ...> |> PontoConnect.BulkPayment.create()
      {:ok, %PontoConnect.BulkPayment{id: "343e64e5-4882-4559-96d0-221c398288f3"}}
  """
  def create(%Request{} = request) do
    request
    |> Request.id("")
    |> Client.execute(:post, @api_schema_path, __MODULE__)
  end

  @doc """
  [Find Bulk Payment by id](https://documentation.ibanity.com/ponto-connect/2/api#get-payment)

  Takes a `Ibanity.PontoConnect.Token`, or a `Ibanity.Request` with set `:customer_access_token` as first argument.

  #{PontoConnect.common_docs!(:account_and_id_second_arg)}

  ## Examples

  #{PontoConnect.common_docs!(:account_id)}

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.PontoConnect.BulkPayment.find(%{account_id: account_or_id, id: "d0e23b50-e150-403b-aa50-581a2329b5f5"})
      {:ok, %Ibanity.PontoConnect.BulkPayment{id: "d0e23b50-e150-403b-aa50-581a2329b5f5"}}

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.Request.customer_access_token()
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
              "resource" => "bulk_payment"
            }
          }
        ]}
  """
  def find(%Request{customer_access_token: customer_access_token} = request_or_token, ids)
      when not is_nil(customer_access_token) do
    formatted_ids = PontoConnect.format_ids(ids)

    request_or_token
    |> Request.ids(formatted_ids)
    |> Client.execute(:get, @api_schema_path, __MODULE__)
  end

  def find(%PontoConnect.Token{} = request_or_token, ids) do
    request_or_token
    |> Request.customer_access_token()
    |> find(ids)
  end

  def find(other, _ids) do
    raise ArgumentError,
      message: PontoConnect.token_argument_error_msg("BulkPayment", other)
  end

  @doc """
  [Delete a Bulk Payment by id](https://documentation.ibanity.com/ponto-connect/2/api#delete-bulk-payment)

  #{PontoConnect.common_docs!(:account_and_id_second_arg)}

  ## Examples

  #{PontoConnect.common_docs!(:account_id)}

  Use `account_or_id` to delete a bulk payment:

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.PontoConnect.BulkPayment.delete(%{
      ...>   id: "953934eb-229a-4fd2-8675-07794078cc7d", account_id: account_or_id
      ...> })
      {:ok, %Ibanity.PontoConnect.BulkPayment{id: "953934eb-229a-4fd2-8675-07794078cc7d"}}

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.Request.customer_access_token()
      ...> |> Ibanity.Request.application(:my_application)
      ...> |> Ibanity.PontoConnect.BulkPayment.delete(%{
      ...>   id: "953934eb-229a-4fd2-8675-07794078cc7d", account_id: account_or_id
      ...> })
      {:ok, %Ibanity.PontoConnect.BulkPayment{id: "953934eb-229a-4fd2-8675-07794078cc7d"}}

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
              "resource" => "bulk_payment"
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
      message: PontoConnect.token_argument_error_msg("BulkPayment", other)
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
