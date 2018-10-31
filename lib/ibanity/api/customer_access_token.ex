defmodule Ibanity.CustomerAccessToken do
  alias Ibanity.{Configuration, Request, ResourceOperations}
  alias Ibanity.Client.Request, as: ClientRequest

  @base_keys [:token]
  defstruct id: nil, token: nil

  def create(%Request{} = request) do
    uri = Map.get(Configuration.api_schema(), "customerAccessTokens")
    client_request = ClientRequest.build(request, uri, "customerAccessToken")

    ResourceOperations.create(client_request, __MODULE__)
  end

  def keys, do: @base_keys
end