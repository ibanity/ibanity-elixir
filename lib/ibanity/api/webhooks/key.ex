defmodule Ibanity.Webhooks.Key do
  @moduledoc """
  Keys API wrapper
  """

  use Ibanity.Resource

  @api_schema_path ~w(webhooks keys)

  defstruct alg: nil,
            e: nil,
            kid: nil,
            kty: nil,
            n: nil,
            status: nil,
            use: nil

  def list, do: list(:default)
  def list(%Request{} = request), do: Client.execute(request, :get, @api_schema_path)
  def list(application), do: list(%Request{application: application})

  def find(kid, application \\ :default) do
    case list(application) do
      {:ok, %{items: keys}} -> {:ok, Enum.find(keys, &(&1.kid == kid))}
      {:error, error} -> {:error, error}
    end
  end

  def key_mapping do
    [
      alg: {~w(alg), :string},
      e: {~w(e), :string},
      kid: {~w(kid), :string},
      n: {~w(n), :string},
      status: {~w(status), :string},
      use: {~w(use), :string}
    ]
  end
end
