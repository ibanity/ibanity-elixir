defmodule Ibanity.PontoConnect.FinancialInstitution do
  @moduledoc """
  [Financial Institutions API wrapper](https://documentation.ibanity.com/ponto-connect/2/api#financial-institution)
  """
  use Ibanity.Resource

  defstruct [
    :id,
    :name,
    :status,
    :depricated,
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
  [List all public financial institutions](https://documentation.ibanity.com/ponto-connect/2/api#list-financial-institutions)

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
  def list_public, do: list_public(%Request{})

  def list_public(%Request{} = request) do
    request
    |> Request.id(:id, "")
    |> Client.execute(:get, @api_schema_path, __MODULE__)
  end

  @doc """

  ## Examples

      iex> Ibanity.PontoConnect.Token{} |> Ibanity.PontoConnect.FinancialInstitution.list_organization()
      {:ok, %Ibanity.Collection{
        items: [%Ibanity.PontoConnect.FinancialInstitution{}]
      }}

      iex> "access-token" |> Ibanity.Request.customer_access_token() |> Ibanity.PontoConnect.FinancialInstitutions.list_organizations()
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
  def list_organization(%Request{customer_access_token: customer_access_token} = request)
      when not is_nil(customer_access_token),
      do: list_public(request)

  def list_organization(%PontoConnect.Token{} = token) do
    token
    |> Request.customer_access_token()
    |> list_organization()
  end

  def list_organization(other) do
    raise ArgumentError, message: token_argument_error_msg(other)
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
          depricated: nil,
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
          depricated: nil,
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
  def find_public(%Request{} = request) do
    Client.execute(request, :get, @api_schema_path, __MODULE__)
  end

  def find_public(id) when is_bitstring(id) do
    id
    |> Request.id()
    |> find_public()
  end

  def find_public(%Request{} = request, id) do
    request
    |> Request.id(id)
    |> find_public()
  end

  @doc """
  [Find public financial institution by id](https://documentation.ibanity.com/ponto-connect/2/api#get-organization-financial-institution)

  Takes a `Ibanity.PontoConnect.Token`, or a `Ibanity.Request` with set `:customer_access_token` as first argument, and a Financial Institution
  ID as second argument.

  ## Examples

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.PontoConnect.FinancialInstitution.find_organization("953934eb-229a-4fd2-8675-07794078cc7d")
      {:ok, %Ibanity.PontoConnect.FinancialInstitution{id: "953934eb-229a-4fd2-8675-07794078cc7d", name: "Fake Bank"}}

      iex> %Ibanity.PontoConnect.Token{}
      ...> |> Ibanity.Request.customer_access_token()
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
  def find_organization(%Request{customer_access_token: customer_access_token} = request, id)
      when not is_nil(customer_access_token) do
    request
    |> Request.id(id)
    |> Client.execute(:get, @api_schema_path, __MODULE__)
  end

  def find_organization(%PontoConnect.Token{} = token, id) do
    token
    |> Request.customer_access_token()
    |> find_organization(id)
  end

  def find_organization(other, _id) do
    raise ArgumentError, message: token_argument_error_msg(other)
  end

  defp token_argument_error_msg(other) do
    """
    Cannot access Financial Institution(s) with given arguments.
    Expected one of:
    - `%Ibanity.Request{}` with `:customer_access_token` set
    - `%Ibanity.PontoConnect.Token{}`

    Got: #{inspect(other)}
    """
  end

  def key_mapping do
    [
      id: {~w(id), :string},
      name: {~w(attributes name), :string},
      status: {~w(attributes status), :string},
      depricated: {~w(attributes depricated), :boolean},
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
