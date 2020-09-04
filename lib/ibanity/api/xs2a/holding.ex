defmodule Ibanity.Xs2a.Holding do
  @moduledoc """
  [Holdings](https://documentation.ibanity.com/xs2a/api#holding) API wrapper
  """

  use Ibanity.Resource

  defstruct id: nil,
            last_valuation_currency: nil,
            last_valuation: nil,
            last_valuation_date: nil,
            total_valuation_currency: nil,
            total_valuation: nil,
            quantity: nil,
            reference: nil,
            reference_type: nil,
            subtype: nil,
            name: nil,
            account_id: nil,
            self: nil

  @api_schema_path ~w(xs2a customer financialInstitution holdings)

  @doc """
  [Lists holdings](https://documentation.ibanity.com/xs2a/api#list-holdings)
  linked to an account belonging to a financial institution.

  Returns `{:ok, collection}` where `collection` is a `Ibanity.Collection` where items are of type `Ibanity.Xs2a.Holding`.

  ## Example

      iex> Request.id(:financial_institution_id, "0f88f06c-3cfe-4b8f-9338-69981c0c4632")
      ...> |> Request.id(:account_id, "ce3893cd-fff5-435a-bdfc-d55a7e98df6f")
      ...> |> Holding.list
      {:ok, %Ibanity.Collection{items: [%Ibanity.Holding{...}], ...}}
  """
  def list(%Request{} = request) do
    request
    |> Request.id(:id, "")
    |> Client.execute(:get, @api_schema_path)
  end

  @doc """
  [Retrieves a holding](https://documentation.ibanity.com/xs2a/api#get-holding)
  linked to an account belonging to an account, based on its id.

  Returns `{:ok, holding}` if successful, {:error, reason} otherwise.

  ## Example

      iex> Request.id(:financial_institution_id, "0f88f06c-3cfe-4b8f-9338-69981c0c4632")
      ...> |> Request.id(:account_id, "ce3893cd-fff5-435a-bdfc-d55a7e98df6f")
      ...> |> Request.id(:id, "9536e9f2-4ee6-4336-b035-40fc2a0424e4")
      ...> |> Holding.find
      {:ok, %Ibanity.Xs2a.Holding{id: "9536e9f2-4ee6-4336-b035-40fc2a0424e4", ...}}

  """
  def find(%Request{} = request) do
    request
    |> Client.execute(:get, @api_schema_path)
  end

  @doc false
  def key_mapping do
    [
      id: {~w(id), :string},
      last_valuation_date: {~w(attributes lastValuationDate), :datetime},
      last_valuation: {~w(attributes lastValuation), :float},
      last_valuation_currency: {~w(attributes totalValuation), :string},
      total_valuation: {~w(attributes totalValuation), :float},
      total_valuation_currency: {~w(attributes totalValuation), :string},
      name: {~w(attributes name), :string},
      reference: {~w(attributes reference), :string},
      reference_type: {~w(attributes referenceType), :string},
      subtype: {~w(attributes subtype), :string},
      quantity: {~w(attributes quantity), :float},
      account_id: {~w(relationships account data id), :string},
      self: {~w(links self), :string}
    ]
  end
end
