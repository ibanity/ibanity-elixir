defmodule Ibanity.Xs2a.Customer do
  @moduledoc """
  [Customer](https://documentation.ibanity.com/xs2a/api#customer) API wrapper
  """

  use Ibanity.Resource

  defstruct [:id]

  @doc """
  [Deletes a customer](https://documentation.ibanity.com/xs2a/api#delete-customer)
  based on the `Ibanity.Xs2a.CustomerAccessToken` set in the request.

  Returns `{:ok, customer}` if customer has been deleted, `{:error, reason}` otherwise.

  ## Example

      iex> token
      ...> |> Request.customer_access_token
      ...> |> Customer.delete
      {:ok %Ibanity.Customer{id: "c017a5ab-a15f-4a77-bf5c-54d29d53e8ab"}}
  """
  def delete(%Request{} = request) do
    request
    |> Client.execute(:delete, ["xs2a", "customer", "self"])
  end

  @doc false
  def key_mapping do
    [id: {~w(id), :string}]
  end
end
