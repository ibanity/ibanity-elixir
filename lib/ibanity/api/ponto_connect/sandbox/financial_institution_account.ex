defmodule Ibanity.PontoConnect.Sandbox.FinancialInstitutionAccount do
  @moduledoc """
  [Sandbox Financial Institution Account](https://documentation.ibanity.com/ponto-connect/api#financial-institution-account) API wrapper
  """

  use Ibanity.Resource

  @api_schema_path [
    "ponto-connect",
    "sandbox",
    "financialInstitution",
    "financialInstitutionAccounts"
  ]

  defstruct [
    :id,
    :description,
    :product,
    :currency,
    :subtype,
    :available_balance,
    :available_balance_changed_at,
    :available_balance_reference_date,
    :current_balance,
    :current_balance_changed_at,
    :current_balance_reference_date,
    :holder_name,
    :reference,
    :reference_type
  ]

  alias Ibanity.PontoConnect

  @doc """
  [List sandbox Financial Institution Accounts](https://documentation.ibanity.com/ponto-connect/2/api#list-financial-institution-accounts)

  Takes a `Ibanity.PontoConnect.Token`, or a `Ibanity.Request` with set `:token` as argument.

  #{PontoConnect.CommonDocs.fetch!(:financial_institution_id)}

  ## Examples

      iex> token |> Ibanity.PontoConnect.Sandbox.FinancialInstitutionAccount.list(financial_institution_or_id)
      {:ok, %Ibanity.Collection{
        items: [%Ibanity.PontoConnect.Sandbox.FinancialInstitutionAccount{}]
      }}

      iex> token |> Ibanity.Request.token() |> Ibanity.PontoConnect.Sandbox.FinancialInstitutionAccount.list(financial_institution_or_id)
      {:ok, %Ibanity.Collection{
        items: [%Ibanity.PontoConnect.Sandbox.FinancialInstitutionAccount{}]
      }}

      iex> invalid_token |> Ibanity.PontoConnect.Sandbox.FinancialInstitutionAccount.list(financial_institution_or_id)
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
        %Request{token: token} = request,
        financial_institution_or_id
      )
      when not is_nil(token) and not is_nil(financial_institution_or_id) do
    formatted_ids =
      PontoConnect.RequestUtils.format_ids(%{
        id: "",
        financial_institution_id: financial_institution_or_id
      })

    request
    |> Request.ids(formatted_ids)
    |> Client.execute(:get, @api_schema_path, __MODULE__)
  end

  def list(%PontoConnect.Token{} = token, financial_institution__or_id) do
    token
    |> Request.token()
    |> list(financial_institution__or_id)
  end

  def list(other, _financial_institution__or_id) do
    raise ArgumentError,
      message:
        PontoConnect.RequestUtils.token_argument_error_msg("FinancialInstitutionAccount", other)
  end

  @doc """
  [Find sandbox Financial Institution Account by id](https://documentation.ibanity.com/ponto-connect/2/api#get-financial-institution-account)

  Takes a `Ibanity.PontoConnect.Token`, or a `Ibanity.Request` with set `:token` as first argument.

  #{PontoConnect.CommonDocs.fetch!(:financial_institution_and_id_second_arg)}

  ## Examples

  #{PontoConnect.CommonDocs.fetch!(:financial_institution_id)}

      iex> token
      ...> |> Ibanity.PontoConnect.Sandbox.FinancialInstitutionAccount.find(%{
      ...>   financial_institution_id: financial_institution_or_id,
      ...>   id: "953934eb-229a-4fd2-8675-07794078cc7d"
      ...> })
      {:ok, %Ibanity.PontoConnect.Sandbox.FinancialInstitutionAccount{id: "953934eb-229a-4fd2-8675-07794078cc7d"}}

      iex> token
      ...> |> Ibanity.Request.token()
      ...> |> Ibanity.Request.application(:my_application)
      ...> |> Ibanity.PontoConnect.Sandbox.FinancialInstitutionAccount.find(%{
      ...>   financial_institution_id: financial_institution_or_id,
      ...>   id: "953934eb-229a-4fd2-8675-07794078cc7d"
      ...> })
      {:ok, %Ibanity.PontoConnect.Sandbox.FinancialInstitutionAccount{id: "953934eb-229a-4fd2-8675-07794078cc7d"}}

      iex> token
      ...> |> Ibanity.PontoConnect.Sandbox.FinancialInstitutionAccount.find(%{
      ...>   financial_institution_id: financial_institution_or_id,
      ...>   id: "does-not-exist"
      ...> })
      {:error,
        [
          %{
            "code" => "resourceNotFound",
            "detail" => "The requested resource was not found.",
            "meta" => %{
              "requestId" => "00077F00000184847F0000011F4066E44223327005A",
              "resource" => "Sandbox.FinancialInstitutionAccount"
            }
          }
        ]}
  """
  def find(
        %Request{} = request_or_token,
        %{financial_institution_id: financial_institution_or_id, id: id} = ids
      )
      when not is_nil(financial_institution_or_id) and not is_nil(id) and
             not is_nil(financial_institution_or_id) do
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

  def find(other, _id) do
    raise ArgumentError,
      message:
        PontoConnect.RequestUtils.token_argument_error_msg("FinancialInstitutionAccount", other)
  end

  @doc false
  def key_mapping do
    [
      id: {["id"], :string},
      description: {["attributes", "description"], :string},
      product: {["attributes", "product"], :string},
      reference: {["attributes", "reference"], :string},
      currency: {["attributes", "currency"], :string},
      subtype: {["attributes", "subtype"], :string},
      available_balance: {["attributes", "availableBalance"], :number},
      available_balance_changed_at: {["attributes", "availableBalanceChangedAt"], :datetime},
      available_balance_reference_date:
        {["attributes", "availableBalanceReferenceDate"], :datetime},
      current_balance: {["attributes", "currentBalance"], :number},
      current_balance_changed_at: {["attributes", "currentBalanceChangedAt"], :datetime},
      current_balance_reference_date: {["attributes", "currentBalanceReferenceDate"], :datetime},
      holder_name: {["attributes", "holderName"], :string},
      reference_type: {["attributes", "referenceType"], :string}
    ]
  end
end
