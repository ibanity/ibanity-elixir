defmodule Ibanity.PontoConnect.FinancialInstitution do
  @moduledoc """
  [Financial Institutions API wrapper](https://documentation.ibanity.com/ponto-connect/2/api#financial-institution)
  """
  use Ibanity.Resource

  defstruct [
    :id,
    :name,
    :status,
    :deprecated,
    :country,
    :bic,
    :bulk_payments_enabled,
    :bulk_payments_product_types,
    :future_dated_payments_allowed,
    :logo_url,
    :maintenance_from,
    :maintenance_to,
    :maintenance_type,
    :payments_enabled,
    :payments_product_types,
    :periodic_payments_enabled,
    :periodic_payments_product_types,
    :primary_color,
    :secondary_color,
    :shared_brand_name,
    :shared_brand_reference,
    :time_zone
  ]

  alias Ibanity.PontoConnect

  @api_schema_path ["ponto-connect", "financialInstitutions"]

  @doc """
  [List public financial institutions](https://documentation.ibanity.com/ponto-connect/2/api#list-financial-institutions)

  ## Examples

      iex> PontoConnect.FinancialInstitution.list_public()
      %Ibanity.Collection{
        items: [
          %Ibanity.PontoConnect.FinancialInstitution{},
          %Ibanity.PontoConnect.FinancialInstitution{},
          %Ibanity.PontoConnect.FinancialInstitution{},
          %Ibanity.PontoConnect.FinancialInstitution{}
        ]
      }


      iex> Request.limit(1)
      ...> |> PontoConnect.FinancialInstitution.list_public()
      %Ibanity.Collection{
        items: [
          %Ibanity.PontoConnect.FinancialInstitution{}
        ],
        page_limit: 1,
        after_cursor: "953934eb-229a-4fd2-8675-07794078cc7d",
        first_link: "https://api.ibanity.com/ponto-connect/financial-institutions?page[limit]=1",
        next_link: "https://api.ibanity.com/ponto-connect/financial-institutions?page[after]=953934eb-229a-4fd2-8675-07794078cc7d&page[limit]=1",
      }
  """
  def list_public(%Request{} = request \\ %Request{}) do
    request
    |> Request.token(nil)
    |> Request.id(:id, "")
    |> Client.execute(:get, @api_schema_path, __MODULE__)
  end

  @doc """
  [List organization's financial institutions](https://documentation.ibanity.com/ponto-connect/2/api#list-organization-financial-institutions)

  Takes a `Ibanity.PontoConnect.Token`, or a `Ibanity.Request` with set `:token` as argument.

  ## Examples

      iex> token |> Ibanity.PontoConnect.FinancialInstitution.list_organization()
      {:ok, %Ibanity.Collection{
        items: [%Ibanity.PontoConnect.FinancialInstitution{}]
      }}

      iex> token |> Ibanity.Request.token() |> Ibanity.PontoConnect.FinancialInstitutions.list_organizations()
      {:ok, %Ibanity.Collection{
        items: [%Ibanity.PontoConnect.FinancialInstitution{}]
      }}

      iex> invalid_token |> Ibanity.PontoConnect.FinancialInstitution.list_organization()
      {:error,
        [
          %{
            "code" => "invalidAccessToken",
            "detail" => "Your access token is invalid.",
            "meta" => %{"requestId" => "00077F000001D3A87F0000011F4066E43AFD1900051"}
          }
        ]}

  """
  def list_organization(%Request{token: token} = request)
      when not is_nil(token) do
    request
    |> Request.id("")
    |> Client.execute(:get, @api_schema_path, __MODULE__)
  end

  def list_organization(%PontoConnect.Token{} = token) do
    token
    |> Request.token()
    |> list_organization()
  end

  def list_organization(other) do
    raise ArgumentError,
      message: PontoConnect.RequestUtils.token_argument_error_msg("Financial Institutions", other)
  end

  @doc """
  [Find public financial institution by id](https://documentation.ibanity.com/ponto-connect/2/api#get-financial-institution)

  ## Examples

      iex> Ibanity.PontoConnect.FinancialInstitution.find_public("953934eb-229a-4fd2-8675-07794078cc7d")
      {:ok,
        %Ibanity.PontoConnect.FinancialInstitution{
          id: "953934eb-229a-4fd2-8675-07794078cc7d",
          name: "Fake Bank",
          status: "stable",
          deprecated: nil,
          country: "BE",
          bic: "NBBEBEBB203",
          bulk_payments_enabled: nil,
          bulk_payments_product_types: nil,
          future_dated_payments_allowed: nil,
          logo_url: nil,
          maintenance_from: nil,
          maintenance_to: nil,
          maintenance_type: nil,
          payments_enabled: nil,
          payments_product_types: nil,
          periodic_payments_enabled: nil,
          periodic_payments_product_types: nil,
          primary_color: nil,
          secondary_color: nil,
          shared_brand_name: nil,
          shared_brand_reference: nil,
          time_zone: nil
        }}

      iex> Ibanity.Request.id("953934eb-229a-4fd2-8675-07794078cc7d")
      ...> |> Ibanity.PontoConnect.FinancialInstitution.find_public()
      {:ok,
        %Ibanity.PontoConnect.FinancialInstitution{
          id: "953934eb-229a-4fd2-8675-07794078cc7d",
          name: "Fake Bank",
          status: "stable",
          deprecated: nil,
          country: "BE",
          bic: "NBBEBEBB203",
          bulk_payments_enabled: nil,
          bulk_payments_product_types: nil,
          future_dated_payments_allowed: nil,
          logo_url: nil,
          maintenance_from: nil,
          maintenance_to: nil,
          maintenance_type: nil,
          payments_enabled: nil,
          payments_product_types: nil,
          periodic_payments_enabled: nil,
          periodic_payments_product_types: nil,
          primary_color: nil,
          secondary_color: nil,
          shared_brand_name: nil,
          shared_brand_reference: nil,
          time_zone: nil
        }}
  """
  def find_public(%Request{token: token} = request_or_token, id) when not is_nil(token) do
    request_or_token
    |> Request.id(id)
    |> Client.execute(:get, @api_schema_path, __MODULE__)
  end

  def find_public(%PontoConnect.Token{} = request_or_token, id) do
    request_or_token
    |> Request.token()
    |> find_public(id)
  end

  def find_public(other, _id) do
    raise ArgumentError,
      message: PontoConnect.RequestUtils.token_argument_error_msg("FinancialInstitution", other)
  end

  @doc """
  [Find organization's financial institution by id](https://documentation.ibanity.com/ponto-connect/2/api#get-organization-financial-institution)

  Takes a `Ibanity.PontoConnect.Token`, or a `Ibanity.Request` with set `:token` as first argument, and a Financial Institution
  ID as second argument.

  ## Examples

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.PontoConnect.FinancialInstitution.find_organization("953934eb-229a-4fd2-8675-07794078cc7d")
      {:ok, %Ibanity.PontoConnect.FinancialInstitution{id: "953934eb-229a-4fd2-8675-07794078cc7d", name: "Fake Bank"}}

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.Request.token()
      ...> |> Ibanity.Request.application(:my_application)
      ...> |> Ibanity.PontoConnect.FinancialInstitution.find_organization("953934eb-229a-4fd2-8675-07794078cc7d")
      {:ok, %Ibanity.PontoConnect.FinancialInstitution{id: "953934eb-229a-4fd2-8675-07794078cc7d", name: "Fake Bank"}}

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.PontoConnect.FinancialInstitution.find_organization("does-not-exist")
      {:error,
        [
          %{
            "code" => "resourceNotFound",
            "detail" => "The requested resource was not found.",
            "meta" => %{
              "requestId" => "00077F00000184847F0000011F4066E44223327005A",
              "resource" => "financialInstitution"
            }
          }
        ]}
  """
  def find_organization(%Request{token: token} = request_or_token, id)
      when not is_nil(token) do
    request_or_token
    |> Request.id(id)
    |> Client.execute(:get, @api_schema_path, __MODULE__)
  end

  def find_organization(%PontoConnect.Token{} = request_or_token, id) do
    request_or_token
    |> Request.token()
    |> find_organization(id)
  end

  def find_organization(other, _id) do
    raise ArgumentError,
      message: PontoConnect.RequestUtils.token_argument_error_msg("FinancialInstitution", other)
  end

  @doc false
  def key_mapping do
    [
      id: {~w(id), :string},
      name: {~w(attributes name), :string},
      status: {~w(attributes status), :string},
      deprecated: {~w(attributes deprecated), :boolean},
      country: {~w(attributes country), :string},
      bic: {~w(attributes bic), :string},
      bulk_payments_enabled: {~w(attributes bulk_payments_enabled), :boolean},
      bulk_payments_product_types: {~w(attributes bulk_payments_product_types), :string},
      future_dated_payments_allowed: {~w(attributes future_dated_payments_allowed), :boolean},
      logo_url: {~w(attributes logo_url), :string},
      maintenance_from: {~w(attributes maintenance_from), :datetime},
      maintenance_to: {~w(attributes maintenance_to), :datetime},
      maintenance_type: {~w(attributes maintenance_type), :string},
      payments_enabled: {~w(attributes payments_enabled), :boolean},
      payments_product_types: {~w(attributes payments_product_types), :string},
      periodic_payments_enabled: {~w(attributes periodic_payments_enabled), :boolean},
      periodic_payments_product_types: {~w(attributes periodic_payments_product_types), :string},
      primary_color: {~w(attributes primary_color), :string},
      secondary_color: {~w(attributes secondary_color), :string},
      shared_brand_name: {~w(attributes shared_brand_name), :string},
      shared_brand_reference: {~w(attributes shared_brand_reference), :string},
      time_zone: {~w(attributes time_zone), :string}
    ]
  end
end
