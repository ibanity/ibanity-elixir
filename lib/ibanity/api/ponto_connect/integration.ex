defmodule Ibanity.PontoConnect.Integration do
  @moduledoc """
  [Integration](https://documentation.ibanity.com/ponto-connect/api#integration) API wrapper

  #{Ibanity.PontoConnect.common_docs!(:client_token)}
  """

  use Ibanity.Resource

  @api_schema_path ["ponto-connect", "organizations", "integration"]

  defstruct [:id]

  alias Ibanity.PontoConnect

  @doc """
  [Revoke Integration by id](https://documentation.ibanity.com/ponto-connect/2/api#revoke-account)

  Takes a `Ibanity.PontoConnect.Token`, or a `Ibanity.Request` with set `:customer_access_token` as first argument.

  Takes a valid organization ID as string as second argument.

  ## Examples

  With token

      iex> Ibanity.PontoConnect.Integration.delete(client_token, "16e79b57-6113-4292-9bfe-87580ff2b317")
      {:ok, %Ibanity.PontoConnect.Integration{id: "501d0365-ce90-4c10-8c5f-0fe259908101"}}

  With request

      iex> client_token
      ...> |> Ibanity.Request.customer_access_token()
      ...> |> Ibanity.Request.application(:my_application)
      ...> |> Ibanity.PontoConnect.Integration.delete("16e79b57-6113-4292-9bfe-87580ff2b317")
      {:ok, %Ibanity.PontoConnect.Integration{id: "501d0365-ce90-4c10-8c5f-0fe259908101"}}

      iex> client_token
      ...> |> Ibanity.PontoConnect.Integration.delete("does-not-exist")
      {:error,
        [
          %{
            "code" => "resourceNotFound",
            "detail" => "The requested resource was not found.",
            "meta" => %{
              "requestId" => "00077F00000184847F0000011F4066E44223327005A",
              "resource" => "integration"
            }
          }
        ]}
  """
  def delete(
        %Request{customer_access_token: customer_access_token} = request,
        organization_id
      )
      when is_bitstring(organization_id) and not is_nil(customer_access_token) do
    request
    |> Request.id(:organization_id, organization_id)
    |> Client.execute(:delete, @api_schema_path, __MODULE__)
  end

  def delete(%PontoConnect.Token{} = token, id) do
    token
    |> Request.customer_access_token()
    |> delete(id)
  end

  def delete(other, _id) do
    raise ArgumentError,
      message: PontoConnect.token_argument_error_msg("Integration", other)
  end

  @doc false
  def key_mapping, do: [id: {["id"], :string}]
end
