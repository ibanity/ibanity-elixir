defmodule Ibanity.Xs2a.FinancialInstitutionCountry do
  @moduledoc """
  [Financial institution countries](https://documentation.ibanity.com/xs2a/api#financial-institution-country) API wrapper
  """

  use Ibanity.Resource

  defstruct id: nil

  @api_schema_path ["xs2a", "financialInstitutionCountries"]

  @doc """
  Lists all countries of the available financial institutions.

  See `list/1`
  """
  def list, do: list(%Request{})

  @doc """
  [Lists all financial institution countries](https://documentation.ibanity.com/xs2a/api#list-financial-institution-countries).

  Returns `{:ok, collection}` where `collection` is a `Ibanity.Collection` where items are of type `Ibanity.Xs2a.FinancialInstitutionCountry`,
  otherwise it returns `{:error, reason}`.

  ## Example

      iex> FinancialInstitutionCountry.list
      {:ok, %Ibanity.Collection{items: [%Ibanity.FinancialInstitutionCountry{...}], ...}
  """

  def list(%Request{} = request) do
    request
    |> Client.execute(:get, @api_schema_path)
  end

  @doc false
  def key_mapping do
    [
      id: {~w(id), :string}
    ]
  end
end
