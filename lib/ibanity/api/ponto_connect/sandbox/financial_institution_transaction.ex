defmodule Ibanity.PontoConnect.Sandbox.FinancialInstitutionTransaction do
  @moduledoc """
  [Sandbox Financial Institution Transaction](https://documentation.ibanity.com/ponto-connect/api#financial-institution-transaction) API wrapper
  """

  use Ibanity.Resource

  @api_schema_path [
    "ponto-connect",
    "sandbox",
    "financialInstitution",
    "financialInstitutionAccount",
    "financialInstitutionTransactions"
  ]

  defstruct [
    :id,
    :description,
    :currency,
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
    :value_date
  ]

  alias Ibanity.PontoConnect

  @doc """
  [Creates a sandbox Financial Institution Transaction](https://documentation.ibanity.com/ponto-connect/api#create-financial-institution-transaction).

  Returns `{:ok, %__MODULE__{}}` if successful, `{:error, reason}` otherwise.

  #{PontoConnect.CommonDocs.fetch!(:financial_institution_and_account_second_arg)}

  ## Examples

  #{PontoConnect.CommonDocs.fetch!(:financial_institution_and_account_ids)}

  Attributes

      iex> attributes = [
      ...>   valueDate: "2020-05-22T00:00:00Z",
      ...>   executionDate: "2020-05-25T00:00:00Z",
      ...>   amount: 84.42,
      ...>   currency: "EUR",
      ...>   counterpartName: "Otro Bank",
      ...>   counterpartReference: "BE9786154282554",
      ...>   description: "Small Cotton Shoes",
      ...>   remittanceInformation: "NEW SHOES",
      ...>   remittanceInformationType: "unstructured",
      ...>   endToEndId: "ref.243435343",
      ...>   purposeCode: "CASH",
      ...>   mandateId: "234",
      ...>   creditorId: "123498765421",
      ...>   additionalInformation: "Online payment on fake-tpp.com",
      ...>   proprietaryBankTransactionCode: "12267",
      ...>   bankTransactionCode: "PMNT-IRCT-ESCT",
      ...>   cardReferenceType: "MASKEDPAN",
      ...>   cardReference: "6666",
      ...>   fee: 3.14
      ...> ]

  IDs

      iex> ids = %{
      ...>   financial_institution_id: financial_institution_or_id,
      ...>   financial_institution_account_id: financial_institution_account_or_id
      ...> }

  Use attributes and ids:

      iex> PontoConnect.Sandbox.FinancialInstitutionTransaction.create(token, ids, attributes)
      {:ok, %PontoConnect.Sandbox.FinancialInstitutionTransaction{id: "343e64e5-4882-4559-96d0-221c398288f3"}}

      iex> request = Request.customer_access_token(token)
      iex> PontoConnect.Sandbox.FinancialInstitutionTransaction.create(request, ids, attributes)
      {:ok, %PontoConnect.Sandbox.FinancialInstitutionTransaction{id: "343e64e5-4882-4559-96d0-221c398288f3"}}
  """
  def create(%PontoConnect.Token{} = request_or_token, ids, attrs) do
    request_or_token
    |> Request.customer_access_token()
    |> create(ids, attrs)
  end

  def create(
        %Request{customer_access_token: token} = request_or_token,
        %{
          financial_institution_id: financial_institution_or_id,
          financial_institution_account_id: financial_institution_account_or_id
        } = ids,
        attrs
      )
      when not is_nil(token) and not is_nil(financial_institution_or_id) and
             not is_nil(financial_institution_account_or_id) and is_list(attrs) do
    formatted_ids = PontoConnect.RequestUtils.format_ids(ids)

    request_or_token
    |> Request.ids(formatted_ids)
    |> Request.attributes(attrs)
    |> create()
  end

  def create(other, _ids, _attrs) do
    raise ArgumentError,
      message:
        PontoConnect.RequestUtils.token_argument_error_msg(
          "FinancialInstitutionTransaction",
          other
        )
  end

  @doc """
  Same as create/3, but `:attributes`, `:account_id`, and `:customer_access_token` must be set in request.

  ## Examples

  Set id and customer_access_token to create a FinancialInstitutionTransaction

      iex> %PontoConnect.Token{}
      ...> |> Request.customer_access_token()
      ...> |> Request.ids(financial_institution_id: financial_institution_id, financial_institution_account_id: financial_institution_account_id)
      ...> |> Request.attributes(attributes)
      ...> |> PontoConnect.FinancialInstitutionTransaction.create()
      {:ok, %PontoConnect.FinancialInstitutionTransaction{id: "343e64e5-4882-4559-96d0-221c398288f3"}}
  """
  def create(%Request{} = request) do
    request
    |> Request.id("")
    |> Client.execute(:post, @api_schema_path, __MODULE__)
  end

  @doc """
  [List sandbox Financial Institution Transactions](https://documentation.ibanity.com/ponto-connect/2/api#list-financial-institution-transactions)

  Takes a `Ibanity.PontoConnect.Token`, or a `Ibanity.Request` with set `:customer_access_token` as argument.

  #{PontoConnect.CommonDocs.fetch!(:financial_institution_and_account_second_arg)}

  ## Examples

  #{PontoConnect.CommonDocs.fetch!(:financial_institution_and_account_ids)}

  Use `financial_institution_or_id` and `financial_institution_account_or_id` to list Financial Institution Transactions

      iex> token |> Ibanity.PontoConnect.Sandbox.FinancialInstitutionTransaction.list(%{
      ...>   financial_institution_id: financial_institution_or_id,
      ...>   financial_institution_account_id: financial_institution_account_or_id
      ...> })
      {:ok, %Ibanity.Collection{
        items: [%Ibanity.PontoConnect.Sandbox.FinancialInstitutionTransaction{}]
      }}

      iex> token |> Ibanity.Request.customer_access_token() |> Ibanity.PontoConnect.Sandbox.FinancialInstitutionTransaction.list(financial_institution_or_id)
      {:ok, %Ibanity.Collection{
        items: [%Ibanity.PontoConnect.Sandbox.FinancialInstitutionTransaction{}]
      }}

      iex> invalid_token |> Ibanity.PontoConnect.Sandbox.FinancialInstitutionTransaction.list(financial_institution_or_id)
      {:error,
        [
          %{
            "code" => "invalidAccessToken",
            "detail" => "Your access token is invalid.",
            "meta" => %{"requestId" => "00077F000001D3A87F0000011F4066E43AFD1900051"}
          }
        ]}

  """
  def list(
        %Request{customer_access_token: token} = request_or_token,
        %{
          financial_institution_id: financial_institution_or_id,
          financial_institution_account_id: financial_institution_account_or_id
        } = ids
      )
      when not is_nil(token) and not is_nil(financial_institution_or_id) and
             not is_nil(financial_institution_account_or_id) do
    formatted_ids =
      ids
      |> Map.put_new(:id, "")
      |> PontoConnect.RequestUtils.format_ids()

    request_or_token
    |> Request.ids(formatted_ids)
    |> Client.execute(:get, @api_schema_path, __MODULE__)
  end

  def list(%PontoConnect.Token{} = token, ids) do
    token
    |> Request.customer_access_token()
    |> list(ids)
  end

  def list(other, _ids) do
    raise ArgumentError,
      message:
        PontoConnect.RequestUtils.token_argument_error_msg(
          "FinancialInstitutionTransaction",
          other
        )
  end

  @doc """
  [Find sandbox Financial Institution Transaction by id](https://documentation.ibanity.com/ponto-connect/2/api#get-financial-institution-transaction)

  Takes a `Ibanity.PontoConnect.Token`, or a `Ibanity.Request` with set `:customer_access_token` as first argument.

  #{PontoConnect.CommonDocs.fetch!(:financial_institution_and_account_second_arg)}

  ## Examples

  #{PontoConnect.CommonDocs.fetch!(:financial_institution_and_account_ids)}

  Use `financial_institution_or_id` and `financial_institution_account_or_id` to find a Financial Institution Transactions

      iex> token
      ...> |> Ibanity.PontoConnect.Sandbox.FinancialInstitutionTransaction.find(%{
      ...>   financial_institution_id: financial_institution_or_id,
      ...>   financial_institution_account_id: financial_institution_account_or_id,
      ...>   id: "953934eb-229a-4fd2-8675-07794078cc7d"
      ...> })
      {:ok, %Ibanity.PontoConnect.Sandbox.FinancialInstitutionTransaction{id: "953934eb-229a-4fd2-8675-07794078cc7d"}}

      iex> token
      ...> |> Ibanity.Request.customer_access_token()
      ...> |> Ibanity.Request.application(:my_application)
      ...> |> Ibanity.PontoConnect.Sandbox.FinancialInstitutionTransaction.find(%{
      ...>   financial_institution_id: financial_institution_or_id,
      ...>   financial_institution_account_id: financial_institution_account_or_id,
      ...>   id: "953934eb-229a-4fd2-8675-07794078cc7d"
      ...> })
      {:ok, %Ibanity.PontoConnect.Sandbox.FinancialInstitutionTransaction{id: "953934eb-229a-4fd2-8675-07794078cc7d"}}

      iex> token
      ...> |> Ibanity.PontoConnect.Sandbox.FinancialInstitutionTransaction.find(%{
      ...>   financial_institution_id: financial_institution_or_id,
      ...>   financial_institution_account_id: financial_institution_account_or_id,
      ...>   id: "does-not-exist"
      ...> })
      {:error,
        [
          %{
            "code" => "resourceNotFound",
            "detail" => "The requested resource was not found.",
            "meta" => %{
              "requestId" => "00077F00000184847F0000011F4066E44223327005A",
              "resource" => "Sandbox.FinancialInstitutionTransaction"
            }
          }
        ]}
  """
  def find(
        %Request{customer_access_token: token} = request_or_token,
        %{
          financial_institution_id: financial_institution_or_id,
          financial_institution_account_id: financial_institution_account_or_id,
          id: id
        } = ids
      )
      when not is_nil(token) and not is_nil(financial_institution_or_id) and not is_nil(id) and
             not is_nil(financial_institution_account_or_id) do
    formatted_ids = PontoConnect.RequestUtils.format_ids(ids)

    request_or_token
    |> Request.ids(formatted_ids)
    |> Client.execute(:get, @api_schema_path, __MODULE__)
  end

  def find(%PontoConnect.Token{} = request_or_token, ids) do
    request_or_token
    |> Request.customer_access_token()
    |> find(ids)
  end

  def find(other, _id) do
    raise ArgumentError,
      message:
        PontoConnect.RequestUtils.token_argument_error_msg(
          "FinancialInstitutionTransaction",
          other
        )
  end

  @doc """
  [Updates an existing financial institution transaction](https://documentation.ibanity.com/xs2a/api#update-financial-institution-transaction)

  Returns `{:ok, %__MODULE__{}}` if successful, `{:error, reason}` otherwise.

  #{PontoConnect.CommonDocs.fetch!(:financial_institution_and_account_second_arg)}

  ## Examples

  #{PontoConnect.CommonDocs.fetch!(:financial_institution_and_account_ids)}

  Attributes

      iex> attributes = [
      ...>   counterpart_name: "Otro Bank",
      ...>   description: "Small Cotton Shoes",
      ...>   remittance_information: "NEW SHOES",
      ...>   end_to_end_id: "ref.243435343",
      ...>   purpose_code: "CASH",
      ...>   mandate_id: "234",
      ...>   creditor_id: "123498765421",
      ...>   additional_information: "Online payment on fake-tpp.com",
      ...>   proprietary_bank_transaction_code: "12267",
      ...>   bank_transaction_code: "PMNT-IRCT-ESCT"
      ...> ]

  IDs

      iex> ids = %{
      ...>   financial_institution_id: financial_institution_or_id,
      ...>   financial_institution_account_id: financial_institution_account_or_id,
      ...>   id: financial_institution_transaction_or_id
      ...> }

  Use `attributes` and `ids`

      iex> PontoConnect.Sandbox.FinancialInstitutionTransaction.update(token, ids, attributes)
      {:ok, %PontoConnect.Sandbox.FinancialInstitutionTransaction{}}

      iex> request = token |> Request.customer_access_token() |> Request.application(:my_application)
      iex> PontoConnect.Sandbox.FinancialInstitutionTransaction.update(request, ids, attributes)
      {:ok, %PontoConnect.Sandbox.FinancialInstitutionTransaction{}}
  """
  def update(%PontoConnect.Token{} = request_or_token, ids, attrs) do
    request_or_token
    |> Request.customer_access_token()
    |> update(ids, attrs)
  end

  def update(
        %Request{customer_access_token: token} = request_or_token,
        %{
          financial_institution_id: financial_institution_or_id,
          financial_institution_account_id: financial_institution_account_or_id,
          id: id
        } = ids,
        attrs
      )
      when not is_nil(token) and not is_nil(financial_institution_or_id) and not is_nil(id) and
             not is_nil(financial_institution_account_or_id) do
    formatted_ids = PontoConnect.RequestUtils.format_ids(ids)

    request_or_token
    |> Request.ids(formatted_ids)
    |> Request.attributes(attrs)
    |> Client.execute(:patch, @api_schema_path, __MODULE__)
  end

  def update(other, _ids, _attrs) do
    raise ArgumentError,
      message:
        PontoConnect.RequestUtils.token_argument_error_msg(
          "FinancialInstitutionTransaction",
          other
        )
  end

  @doc false
  def key_mapping do
    [
      id: {["id"], :string},
      description: {["attributes", "description"], :string},
      currency: {["attributes", "currency"], :string},
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
      value_date: {["attributes", "valueDate"], :datetime}
    ]
  end
end
