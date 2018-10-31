defmodule Ibanity.CustomerAccessToken do
  alias Ibanity.{Configuration, Request, ResourceOperations}
  alias Ibanity.Client.Request, as: ClientRequest

  defstruct id: nil, token: nil

  def create(%Request{} = request) do
    uri = Map.get(Configuration.api_schema(), "customerAccessTokens")
    client_request = ClientRequest.build(request, uri, "customerAccessToken")

    ResourceOperations.create(client_request, __MODULE__)
  end

  def key_mapping do
    [
      id: ~w(id),
      token: ~w(attributes token)
    ]
  end
end