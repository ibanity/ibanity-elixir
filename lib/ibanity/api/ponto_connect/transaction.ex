defmodule Ibanity.PontoConnect.Transaction do
  @moduledoc """
  [Transactions API wrapper](https://documentation.ibanity.com/ponto-connect/2/api#transaction)
  """
  use Ibanity.Resource

  defstruct [
    :id,
    :description,
    :currency,
    :digest,
    :created_at,
    :updated_at,
    :amount,
    :fee,
    :additional_information,
    :bank_transaction_code,
    :card_reference,
    :card_reference_type,
    :counterpart_name,
    :counterpart_reference,
    :creditor_id,
    :end_to_end_id,
    :execution_date,
    :mandate_id,
    :proprietary_bank_transaction_code,
    :purpose_code,
    :remittance_information,
    :remittance_information_type,
    :value_date,
    :internal_reference
  ]

  alias Ibanity.PontoConnect

  @api_schema_path ["ponto-connect", "account", "transactions"]
  @api_schema_synchronization_path ["ponto-connect", "synchronization"]
  @api_schema_account_path ["ponto-connect", "account"]

  @doc """
  [List transactions](https://documentation.ibanity.com/ponto-connect/2/api#list-transactions)

  Takes a `Ibanity.PontoConnect.Token`, or a `Ibanity.Request` with set `:customer_access_token` as first argument.

  Takes a `Ibanity.PontoConnect.Account` or the account id as a string as second argument.

  ## Examples

  #{PontoConnect.CommonDocs.fetch!(:account_id)}

  Use account or id to list transactions:

      iex> Ibanity.PontoConnect.Token{} |> Ibanity.PontoConnect.Transaction.list(account_or_id)
      {:ok, %Ibanity.Collection{
        items: [%Ibanity.PontoConnect.Transaction{}]
      }}

      iex> "access-token" |> Ibanity.Request.customer_access_token() |> Ibanity.PontoConnect.Transaction.list(account_or_id)
      {:ok, %Ibanity.Collection{
        items: [%Ibanity.PontoConnect.Transaction{}]
      }}

      iex> invalid_token |> Ibanity.PontoConnect.Transaction.list(account_or_id)
      {:error,
        [
          %{
            "code" => "invalidAccessToken",
            "detail" => "Your access token is invalid.",
            "meta" => %{"requestId" => "00077F000001D3A87F0000011F4066E43AFD1900051"}
          }
        ]}
  """
  def list(request_or_token, %PontoConnect.Account{id: account_id}),
    do: list(request_or_token, account_id)

  def list(%Request{customer_access_token: customer_access_token} = request, account_id)
      when not is_nil(customer_access_token) and is_bitstring(account_id) do
    request
    |> Request.ids(id: "", account_id: account_id)
    |> Client.execute(:get, @api_schema_path, __MODULE__)
  end

  def list(%PontoConnect.Token{} = token, account_id) do
    token
    |> Request.customer_access_token()
    |> list(account_id)
  end

  def list(other, _account_id) do
    raise ArgumentError,
      message: PontoConnect.token_argument_error_msg("Transactions", other)
  end

  @doc """
  [List updated Transactions for synchronizations](https://documentation.ibanity.com/ponto-connect/2/api#list-updated-transactions-for-synchronization)

  Takes a `Ibanity.PontoConnect.Token`, or a `Ibanity.Request` with set `:customer_access_token` as first argument.

  Takes a map with the following keys as second argument:
  - `:synchronization``Ibanity.PontoConnect.Synchronization` struct or account ID as a string
  - `:id` Transaction ID as a string

  #{PontoConnect.CommonDocs.fetch!(:synchronization_id)}

  ## Examples

  Use synchronization or id to list updated transactions:

      iex> Ibanity.PontoConnect.Token{} |> Ibanity.PontoConnect.Transaction.list_updated_for_transaction(account_or_id)
      {:ok, %Ibanity.Collection{
        items: [%Ibanity.PontoConnect.Transaction{}]
      }}

      iex> "access-token" |> Ibanity.Request.customer_access_token() |> Ibanity.PontoConnect.Transaction.list_updated_for_transaction(account_or_id)
      {:ok, %Ibanity.Collection{
        items: [%Ibanity.PontoConnect.Transaction{}]
      }}

      iex> invalid_token |> Ibanity.PontoConnect.Transaction.list_updated_for_transaction(account_or_id)
      {:error,
        [
          %{
            "code" => "invalidAccessToken",
            "detail" => "Your access token is invalid.",
            "meta" => %{"requestId" => "00077F000001D3A87F0000011F4066E43AFD1900051"}
          }
        ]}

      iex> 
  """
  def list_updated_for_synchronization(
        %Request{} = request_or_token,
        %PontoConnect.Synchronization{
          id: synchronization_id
        }
      ),
      do: list_updated_for_synchronization(request_or_token, synchronization_id)

  def list_updated_for_synchronization(
        %Request{customer_access_token: customer_access_token} = request,
        synchronization_id
      )
      when not is_nil(customer_access_token) and is_bitstring(synchronization_id) do
    api_schema_path = List.insert_at(@api_schema_synchronization_path, -1, "updatedTransactions")

    request
    |> Request.ids(id: "", synchronization_id: synchronization_id)
    |> Client.execute(:get, api_schema_path, __MODULE__)
  end

  def list_updated_for_synchronization(%PontoConnect.Token{} = token, synchronization_id) do
    token
    |> Request.customer_access_token()
    |> list_updated_for_synchronization(synchronization_id)
  end

  def list_updated_for_synchronization(other, _synchronization_id) do
    raise ArgumentError,
      message: PontoConnect.token_argument_error_msg("Transactions", other)
  end

  @doc """
  [List updated pending Transactions for synchronizations](https://documentation.ibanity.com/ponto-connect/2/api#list-updated-pending-transactions-for-synchronization)

  Takes a `Ibanity.PontoConnect.Token`, or a `Ibanity.Request` with set `:customer_access_token` as first argument.

  Takes a map with the following keys as second argument:
  - `:synchronization``Ibanity.PontoConnect.Synchronization` struct or account ID as a string
  - `:id` Transaction ID as a string

  #{PontoConnect.CommonDocs.fetch!(:synchronization_id)}

  ## Examples

  Use synchronization or id to list updated transactions:

      iex> Ibanity.PontoConnect.Token{} |> Ibanity.PontoConnect.Transaction.list_updated_pending_for_synchronization(synchronization_or_id)
      {:ok, %Ibanity.Collection{
        items: [%Ibanity.PontoConnect.Transaction{}]
      }}

      iex> "access-token" |> Ibanity.Request.customer_access_token() |> Ibanity.PontoConnect.Transaction.list_updated_pending_for_synchronization(synchronization_or_id)
      {:ok, %Ibanity.Collection{
        items: [%Ibanity.PontoConnect.Transaction{}]
      }}

      iex> invalid_token |> Ibanity.PontoConnect.Transaction.list_updated_pending_for_synchronization(synchronization_or_id)
      {:error,
        [
          %{
            "code" => "invalidAccessToken",
            "detail" => "Your access token is invalid.",
            "meta" => %{"requestId" => "00077F000001D3A87F0000011F4066E43AFD1900051"}
          }
        ]}
  """
  def list_updated_pending_for_synchronization(
        %Request{} = request_or_token,
        %PontoConnect.Synchronization{
          id: synchronization_id
        }
      ),
      do: list_updated_pending_for_synchronization(request_or_token, synchronization_id)

  def list_updated_pending_for_synchronization(
        %Request{customer_access_token: customer_access_token} = request,
        synchronization_id
      )
      when not is_nil(customer_access_token) and is_bitstring(synchronization_id) do
    api_schema_path = List.insert_at(@api_schema_synchronization_path, -1, "updatedTransactions")

    request
    |> Request.ids(id: "", synchronization_id: synchronization_id)
    |> Client.execute(:get, api_schema_path, __MODULE__)
  end

  def list_updated_pending_for_synchronization(%PontoConnect.Token{} = token, synchronization_id) do
    token
    |> Request.customer_access_token()
    |> list_updated_pending_for_synchronization(synchronization_id)
  end

  def list_updated_pending_for_synchronization(other, _synchronization_id) do
    raise ArgumentError,
      message: PontoConnect.token_argument_error_msg("Transactions", other)
  end

  @doc """
  [List updated pending transactions](https://documentation.ibanity.com/ponto-connect/2/api#pending-transactions)

  Takes a `Ibanity.PontoConnect.Token`, or a `Ibanity.Request` with set `:customer_access_token` as first argument.

  Takes a `Ibanity.PontoConnect.Account` or the account id as a string as second argument.

  ## Examples

  #{PontoConnect.CommonDocs.fetch!(:account_id)}

  Use account or id to list transactions:

      iex> Ibanity.PontoConnect.Token{} |> Ibanity.PontoConnect.Transaction.list_pending_for_account(account_or_id)
      {:ok, %Ibanity.Collection{
        items: [%Ibanity.PontoConnect.Transaction{}]
      }}

      iex> "access-token" |> Ibanity.Request.customer_access_token() |> Ibanity.PontoConnect.Transaction.list_pending_for_account(account_or_id)
      {:ok, %Ibanity.Collection{
        items: [%Ibanity.PontoConnect.Transaction{}]
      }}

      iex> invalid_token |> Ibanity.PontoConnect.Transaction.list_pending_for_account(account_or_id)
      {:error,
        [
          %{
            "code" => "invalidAccessToken",
            "detail" => "Your access token is invalid.",
            "meta" => %{"requestId" => "00077F000001D3A87F0000011F4066E43AFD1900051"}
          }
        ]}
  """
  def list_pending_for_account(request_or_token, %PontoConnect.Account{id: account_id}),
    do: list_pending_for_account(request_or_token, account_id)

  def list_pending_for_account(
        %Request{customer_access_token: customer_access_token} = request,
        account_id
      )
      when not is_nil(customer_access_token) and is_bitstring(account_id) do
    api_schema_path = List.insert_at(@api_schema_account_path, -1, "pendingTransactions")

    request
    |> Request.ids(id: "", account_id: account_id)
    |> Client.execute(:get, api_schema_path, __MODULE__)
  end

  def list_pending_for_account(%PontoConnect.Token{} = token, account_id) do
    token
    |> Request.customer_access_token()
    |> list_pending_for_account(account_id)
  end

  def list_pending_for_account(other, _account_id) do
    raise ArgumentError,
      message: PontoConnect.token_argument_error_msg("Transactions", other)
  end

  @doc """
  [Find Transaction by id](https://documentation.ibanity.com/ponto-connect/2/api#get-transaction)

  Takes a `Ibanity.PontoConnect.Token`, or a `Ibanity.Request` with set `:customer_access_token` as first argument.

  #{PontoConnect.CommonDocs.fetch!(:account_and_id_second_arg)}

  ## Examples

  #{PontoConnect.CommonDocs.fetch!(:account_id)}

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.PontoConnect.Transaction.find(%{account_id: account_or_id, id: "d0e23b50-e150-403b-aa50-581a2329b5f5"})
      {:ok, %Ibanity.PontoConnect.Transaction{id: "d0e23b50-e150-403b-aa50-581a2329b5f5"}}

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.Request.customer_access_token()
      ...> |> Ibanity.Request.application(:my_application)
      ...> |> Ibanity.PontoConnect.Transaction.find(%{account_id: account_or_id, id: "d0e23b50-e150-403b-aa50-581a2329b5f5"})
      {:ok, %Ibanity.PontoConnect.Transaction{id: "d0e23b50-e150-403b-aa50-581a2329b5f5"}}

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.PontoConnect.Transaction.find(%{account_id: account_or_id, id: "does-not-exist"})
      {:error,
        [
          %{
            "code" => "resourceNotFound",
            "detail" => "The requested resource was not found.",
            "meta" => %{
              "requestId" => "00077F00000184847F0000011F4066E44223327005A",
              "resource" => "transaction"
            }
          }
        ]}
  """
  def find(%Request{customer_access_token: customer_access_token} = request, ids)
      when not is_nil(customer_access_token) do
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

  def find(other, _ids) do
    raise ArgumentError,
      message: PontoConnect.token_argument_error_msg("Transaction", other)
  end

  @doc """
  [Find pending Transaction by id](https://documentation.ibanity.com/ponto-connect/2/api#get-pending-transaction)

  Takes a `Ibanity.PontoConnect.Token`, or a `Ibanity.Request` with set `:customer_access_token` as first argument.

  Takes a map with the following keys as second argument:
  - `:account_id``Ibanity.PontoConnect.Account` struct or account ID as a string
  - `:id` Transaction ID as a string

  #{PontoConnect.CommonDocs.fetch!(:account_id)}

  ## Examples

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.PontoConnect.Transaction.find_pending_for_account(%{account_id: account_or_id, id: "d0e23b50-e150-403b-aa50-581a2329b5f5"})
      {:ok, %Ibanity.PontoConnect.Transaction{id: "d0e23b50-e150-403b-aa50-581a2329b5f5"}}

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.Request.customer_access_token()
      ...> |> Ibanity.Request.application(:my_application)
      ...> |> Ibanity.PontoConnect.Transaction.find_pending_for_account(%{account_id: account_or_id, id: "d0e23b50-e150-403b-aa50-581a2329b5f5"})
      {:ok, %Ibanity.PontoConnect.Transaction{id: "d0e23b50-e150-403b-aa50-581a2329b5f5"}}

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.PontoConnect.Transaction.find_pending_for_account(%{account_id: account_or_id, id: "does-not-exist"})
      {:error,
        [
          %{
            "code" => "resourceNotFound",
            "detail" => "The requested resource was not found.",
            "meta" => %{
              "requestId" => "00077F00000184847F0000011F4066E44223327005A",
              "resource" => "transaction"
            }
          }
        ]}
  """
  def find_pending_for_account(
        %Request{customer_access_token: customer_access_token} = request,
        ids
      )
      when not is_nil(customer_access_token) do
    formatted_ids = PontoConnect.format_ids(ids)

    request
    |> Request.ids(formatted_ids)
    |> Client.execute(:get, @api_schema_path, __MODULE__)
  end

  def find_pending_for_account(%PontoConnect.Token{} = token, ids) do
    token
    |> Request.customer_access_token()
    |> find_pending_for_account(ids)
  end

  def find_pending_for_account(other, _ids) do
    raise ArgumentError,
      message: PontoConnect.token_argument_error_msg("Transaction", other)
  end

  @doc false
  def key_mapping do
    [
      id: {["id"], :string},
      description: {["attributes", "description"], :string},
      currency: {["attributes", "currency"], :string},
      digest: {["attributes", "digest"], :string},
      created_at: {["attributes", "createdAt"], :datetime},
      updated_at: {["attributes", "updatedAt"], :datetime},
      amount: {["attributes", "amount"], :number},
      fee: {["attributes", "fee"], :number},
      additional_information: {["attributes", "additionalInformation"], :string},
      bank_transaction_code: {["attributes", "bankTransactionCode"], :string},
      card_reference: {["attributes", "cardReference"], :string},
      card_reference_type: {["attributes", "cardReferenceType"], :string},
      counterpart_name: {["attributes", "counterpartName"], :string},
      counterpart_reference: {["attributes", "counterpartReference"], :string},
      creditor_id: {["attributes", "creditorId"], :string},
      end_to_end_id: {["attributes", "endToEndId"], :string},
      execution_date: {["attributes", "executionDate"], :datetime},
      mandate_id: {["attributes", "mandateId"], :string},
      proprietary_bank_transaction_code:
        {["attributes", "proprietaryBankTransactionCode"], :string},
      purpose_code: {["attributes", "purposeCode"], :string},
      remittance_information: {["attributes", "remittanceInformation"], :string},
      remittance_information_type: {["attributes", "remittanceInformationType"], :string},
      value_date: {["attributes", "valueDate"], :datetime},
      internal_reference: {["attributes", "internalReference"], :string}
    ]
  end
end
