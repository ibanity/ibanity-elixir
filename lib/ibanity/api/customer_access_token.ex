defmodule Ibanity.CustomerAccessToken do
  @moduledoc """
  Customer access token API wrapper
  """

  use Ibanity.Resource

  defstruct id: nil, token: nil

  @api_schema_path  ["customerAccessTokens"]

  def create(%Request{} = request) do
    request
    |> Client.execute(:post, @api_schema_path)
  end

  def key_mapping do
    [
      id: ~w(id),
      token: ~w(attributes token)
    ]
  end
end
