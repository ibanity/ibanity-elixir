defmodule Ibanity.PontoConnect.Account do
  @moduledoc """
  [Account API wrapper](https://documentation.ibanity.com/ponto-connect/2/api#account)
  """

  use Ibanity.Resource

  alias Ibanity.PontoConnect

  @api_schema_path ["ponto-connect", "accounts"]

  defstruct [
    :id,
    :description,
    :deprecated,
    :product,
    :reference,
    :currency,
    :subtype,
    :available_balance,
    :available_balance_changed_at,
    :available_balance_reference_date,
    :current_balance,
    :current_balance_changed_at,
    :current_balance_reference_date,
    :holder_name,
    :reference_type,
    :authorization_expiration_expected_at,
    :authorized_at,
    :available_balance_variation_observed_at,
    :current_balance_variation_observed_at,
    :internal_reference,
    :availability,
    :latest_synchronization,
    :synchronized_at
  ]

  @doc """
  [List accounts](https://documentation.ibanity.com/ponto-connect/2/api#list-accounts)

  Takes a `Ibanity.PontoConnect.Token`, or a `Ibanity.Request` with set `:token` as argument.

  ## Examples

      iex> Ibanity.PontoConnect.Account.list(token)
      {:ok, %Ibanity.Collection{
        items: [%Ibanity.PontoConnect.Account{}]
      }}

      iex> token |> Ibanity.Request.token() |> Ibanity.PontoConnect.Accounts.list()
      {:ok, %Ibanity.Collection{
        items: [%Ibanity.PontoConnect.Account{}]
      }}

      iex> invalid_token |> Ibanity.PontoConnect.Account.list()
      {:error,
        [
          %{
            "code" => "invalidAccessToken",
            "detail" => "Your access token is invalid.",
            "meta" => %{"requestId" => "00077F000001D3A87F0000011F4066E43AFD1900051"}
          }
        ]}

  """
  def list(%Request{token: token} = request_or_token)
      when not is_nil(token) do
    request_or_token
    |> Request.id(:id, "")
    |> Client.execute(:get, @api_schema_path, __MODULE__)
  end

  def list(%PontoConnect.Token{} = request_or_token) do
    request_or_token
    |> Request.token()
    |> list()
  end

  def list(other) do
    raise ArgumentError,
      message: PontoConnect.Exceptions.token_argument_error_msg("Accounts", other)
  end

  @doc """
  [Find Account by id](https://documentation.ibanity.com/ponto-connect/2/api#get-account)

  Takes a `Ibanity.PontoConnect.Token`, or a `Ibanity.Request` with set `:token` as first argument, and a Account
  ID as second argument.

  ## Examples

  With token

      iex> Ibanity.PontoConnect.Account.find(token, "953934eb-229a-4fd2-8675-07794078cc7d")
      {:ok, %Ibanity.PontoConnect.Account{id: "953934eb-229a-4fd2-8675-07794078cc7d"}}

  With request

      iex> token
      ...> |> Ibanity.Request.token()
      ...> |> Ibanity.Request.application(:my_application)
      ...> |> Ibanity.PontoConnect.Account.find("953934eb-229a-4fd2-8675-07794078cc7d")
      {:ok, %Ibanity.PontoConnect.Account{id: "953934eb-229a-4fd2-8675-07794078cc7d"}}

  Error

      iex> Ibanity.PontoConnect.Account.find(token, "does-not-exist")
      {:error,
        [
          %{
            "code" => "resourceNotFound",
            "detail" => "The requested resource was not found.",
            "meta" => %{
              "requestId" => "00077F00000184847F0000011F4066E44223327005A",
              "resource" => "account"
            }
          }
        ]}
  """
  def find(%Request{token: token} = request_or_token, id)
      when not is_nil(token) do
    request_or_token
    |> Request.id(id)
    |> Client.execute(:get, @api_schema_path, __MODULE__)
  end

  def find(%PontoConnect.Token{} = request_or_token, id) do
    request_or_token
    |> Request.token()
    |> find(id)
  end

  def find(other, _id) do
    raise ArgumentError,
      message: PontoConnect.Exceptions.token_argument_error_msg("Account", other)
  end

  @doc """
  [Revoke Account by id](https://documentation.ibanity.com/ponto-connect/2/api#revoke-account)

  ## Examples

  With token

      iex> Ibanity.PontoConnect.Account.delete(token, "953934eb-229a-4fd2-8675-07794078cc7d")
      {:ok, %Ibanity.PontoConnect.Account{id: "953934eb-229a-4fd2-8675-07794078cc7d"}}

  With request

      iex> token
      ...> |> Ibanity.Request.token()
      ...> |> Ibanity.Request.application(:my_application)
      ...> |> Ibanity.PontoConnect.Account.delete("953934eb-229a-4fd2-8675-07794078cc7d")
      {:ok, %Ibanity.PontoConnect.Account{id: "953934eb-229a-4fd2-8675-07794078cc7d"}}

  Error

      iex> Ibanity.PontoConnect.Account.delete(token, "does-not-exist")
      {:error,
        [
          %{
            "code" => "resourceNotFound",
            "detail" => "The requested resource was not found.",
            "meta" => %{
              "requestId" => "00077F00000184847F0000011F4066E44223327005A",
              "resource" => "account"
            }
          }
        ]}
  """
  def delete(%Request{token: token} = request_or_token, id)
      when not is_nil(token) do
    formatted_ids = PontoConnect.RequestUtils.format_ids(%{id: id})

    request_or_token
    |> Request.ids(formatted_ids)
    |> Client.execute(:delete, @api_schema_path, __MODULE__)
  end

  def delete(%PontoConnect.Token{} = request_or_token, id) do
    request_or_token
    |> Request.token()
    |> delete(id)
  end

  def delete(other, _id) do
    raise ArgumentError,
      message: PontoConnect.Exceptions.token_argument_error_msg("Account", other)
  end

  @doc false
  def key_mapping do
    [
      id: {~w(id), :string},
      description: {~w(attributes description), :string},
      deprecated: {~w(attributes deprecated), :boolean},
      product: {~w(attributes product), :string},
      reference: {~w(attributes reference), :string},
      currency: {~w(attributes currency), :string},
      subtype: {~w(attributes subtype), :string},
      available_balance: {~w(attributes available_balance), :number},
      available_balance_changed_at: {~w(attributes available_balance_changed_at), :datetime},
      available_balance_reference_date: {~w(attributes available_balance_reference_date), :date},
      current_balance: {~w(attributes current_balance), :number},
      current_balance_changed_at: {~w(attributes current_balance_changed_at), :datetime},
      current_balance_reference_date: {~w(attributes current_balance_reference_date), :date},
      holder_name: {~w(attributes holder_name), :string},
      reference_type: {~w(attributes reference_type), :string},
      authorization_expiration_expected_at:
        {~w(attributes authorization_expiration_expected_at), :datetime},
      authorized_at: {~w(attributes authorized_at), :datetime},
      available_balance_variation_observed_at:
        {~w(attributes available_balance_variation_observed_at), :datetime},
      current_balance_variation_observed_at:
        {~w(attributes current_balance_variation_observed_at), :datetime},
      internal_reference: {~w(attributes internal_reference), :string},
      avilability: {~w(meta availability), :string},
      latest_synchronization: {~w(meta latest_synchronization), :map},
      synchronized_at: {~w(meta synchronized_at), :datetime}
    ]
  end
end
