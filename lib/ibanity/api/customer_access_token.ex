defmodule Ibanity.CustomerAccessToken do
  alias Ibanity.{Request, ResourceOperations}
  alias Ibanity.Client.Request, as: ClientRequest

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