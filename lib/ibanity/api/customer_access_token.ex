defmodule Ibanity.CustomerAccessToken do
  @moduledoc """
  Customer access token API wrapper
  """

  alias Ibanity.Client.Request, as: ClientRequest
  alias Ibanity.{Request, ResourceOperations}

  defstruct id: nil, token: nil

  @api_schema_path  ["customerAccessTokens"]

  def create(%Request{} = request) do
    request
    |> ClientRequest.build(@api_schema_path, "customerAccessToken")
    |> ResourceOperations.create(__MODULE__)
  end

  def key_mapping do
    [
      id: ~w(id),
      token: ~w(attributes token)
    ]
  end
end
