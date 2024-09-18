defmodule Ibanity.PontoConnect.Usage do
  @moduledoc """
  [Payment Activation Request](https://documentation.ibanity.com/ponto-connect/api#payment-activation-request) API wrapper

  #{Ibanity.PontoConnect.CommonDocs.fetch!(:client_token)}
  """

  use Ibanity.Resource

  @api_schema_path ["ponto-connect", "organizations", "usage"]

  defstruct [
    :account_count,
    :bulk_payment_bundle_count,
    :bulk_payment_count,
    :payment_account_count,
    :payment_count
  ]

  alias Ibanity.PontoConnect

  @doc """
  [Find organization's Usage for a given month](https://documentation.ibanity.com/ponto-connect/2/api#get-organization-usage)

  Takes a `Ibanity.PontoConnect.Token`, or a `Ibanity.Request` with set `:customer_access_token` as first argument.

  Takes a map with the following keys as second argument:
  - `:organization_id`: a valid organization ID as string
  - `:month`: month of a year in the format `"[year]-[month]"` e.g. `"2024-09"`

  ## Examples

  Attributes

      iex> attributes = %{
      ...>   organization_id: "16e79b57-6113-4292-9bfe-87580ff2b317",
      ...>   month: "2024-09"
      ...> }

  With client token

      iex> Ibanity.PontoConnect.Usage.find(client_token, attributes)
      {:ok, %Ibanity.PontoConnect.Usage{account_count: 7}}

  With request

      iex> client_token
      ...> |> Ibanity.Request.customer_access_token()
      ...> |> Ibanity.Request.application(:my_application)
      ...> |> Ibanity.PontoConnect.Usage.find(attributes)
      {:ok, %Ibanity.PontoConnect.Sandbox.Usage{id: "953934eb-229a-4fd2-8675-07794078cc7d"}}

  error

      iex> Ibanity.PontoConnect.Usage.find(client_token, %{organization_id: "does-not-exist", month: "2024-09"})
      {:error,
        [
          %{
            "code" => "resourceNotFound",
            "detail" => "The requested resource was not found.",
            "meta" => %{
              "requestId" => "00077F00000184847F0000011F4066E44223327005A",
              "resource" => "Usage"
            }
          }
        ]}
  """
  def find(
        %Request{customer_access_token: token} = request_or_token,
        %{
          month: month,
          organization_id: organization_id
        }
      )
      when not is_nil(token) and not is_nil(month) and not is_nil(organization_id) do
    formatted_ids = [id: month, organization_id: organization_id]

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
      message: PontoConnect.token_argument_error_msg("FinancialInstitutionTransaction", other)
  end

  @doc false
  def key_mapping do
    [
      account_count: {["attributes", "accountCount"], :number},
      bulk_payment_bundle_count: {["attributes", "bulkPaymentBundleCount"], :number},
      bulk_payment_count: {["attributes", "bulkPaymentCount"], :number},
      payment_account_count: {["attributes", "paymentAccountCount"], :number},
      payment_count: {["attributes", "paymentCount"], :number}
    ]
  end
end
