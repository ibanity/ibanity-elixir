defmodule Ibanity.CustomerAccessToken do
  @moduledoc """
  [Customer access token](https://documentation.ibanity.com/api#c) API wrapper
  """

  use Ibanity.Resource

  defstruct id: nil, token: nil

  @api_schema_path ["customerAccessTokens"]

  @doc """
  [Requests a customer access token](https://documentation.ibanity.com/api#create-customer-access-token)

  ## Example

      iex> [application_customer_reference: "12345"]
      ...> |> Request.attributes
      ...> |> CustomerAccessToken.create
      {:ok,
        %Ibanity.CustomerAccessToken{
          id: "9211c5a6-9201-45a3-a8f8-30d705613190",
          token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9..."
        }
      }
  """
  def create(%Request{} = request) do
    request
    |> Client.execute(:post, @api_schema_path)
  end

  @doc false
  def key_mapping do
    [
      id: {~w(id), :string},
      token: {~w(attributes token), :string}
    ]
  end
end
