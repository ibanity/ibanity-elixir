defmodule Ibanity.Customer do
  @moduledoc """
  Customer API wrapper
  """

  use Ibanity.Resource

  defstruct [:id]

  def delete(%Request{} = request) do
    request
    |> Client.execute(:delete, ["customer", "self"], __MODULE__)
  end

  def key_mapping do
    [id: ~w(id)]
  end
end
