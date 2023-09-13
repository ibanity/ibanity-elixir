defmodule Ibanity.Sandbox.FinancialInstitutionHolding do
  @moduledoc """
  [Financial institution holding]() API wrapper
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionHolding instead"

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
            created_at: nil,
            updated_at: nil,
            financial_institution_account_id: nil

  @doc """
  Convenience function to [create a new financial institution holding](https://documentation.ibanity.com/xs2a/api#create-financial-institution-holding).

  See `create/1`

  ## Example
      iex> attributes = [
      ...> last_valuation_currency: "USD",
      ...> last_valuation: 105.5,
      ...> last_valuation_date: "2020-01-01",
      ...> total_valuation_currency: "USD",
      ...> total_valuation: 1055,
      ...>   ...
      ...> ]
      ...> FinancialInstitutionHolding.create(
      ...>   "ad6fa583-2616-4a11-8b8d-eb98c53e2905",
      ...>   "740b6ae8-a631-4a32-9afc-a5548ab99d7e",
      ...>   "d9d60751-b741-4fa6-8524-8f9a066ca037",
      ...>   attributes
      ...> )
      {:ok, %Ibanity.FinancialInstitutionHolding{id: "44cd2dc8-163a-4dbe-b544-869e5f84ea54", ...}}
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionHolding.create/5 instead"
  def create(
        %Request{} = request,
        financial_institution_id,
        financial_institution_user_id,
        financial_institution_account_id,
        attributes
      ) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionHolding.create(
      request,
      financial_institution_id,
      financial_institution_user_id,
      financial_institution_account_id,
      attributes
    )
  end

  @doc """
  [Creates a new financial institution holding](https://documentation.ibanity.com/xs2a/api#create-financial-institution-holding).

  Returns `{:ok, holding}` if successful, `{:error, reason}` otherwise
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionHolding.create/1 instead"
  def create(%Request{} = request) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionHolding.create(request)
  end

  @doc """
  [List holdings]() linked to a financial institution user account

   ## Example
      iex> FinancialInstitutionHolding.list(
      ...>   "ad6fa583-2616-4a11-8b8d-eb98c53e2905",
      ...>   "740b6ae8-a631-4a32-9afc-a5548ab99d7e",
      ...>   "d9d60751-b741-4fa6-8524-8f9a066ca037"
      ...> )
      %Ibanity.Collection[items: [Ibanity.FinancialInstitutionHolding{id: "44cd2dc8-163a-4dbe-b544-869e5f84ea54", ...}], ...]
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionHolding.list/4 instead"
  def list(
        %Request{} = request,
        financial_institution_id,
        financial_institution_user_id,
        financial_institution_account_id
      ) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionHolding.list(
      request,
      financial_institution_id,
      financial_institution_user_id,
      financial_institution_account_id
    )
  end

  @doc """
  [Lists holdings](https://documentation.ibanity.com/xs2a/api#list-financial-institution-holdings) linked to a financial institution user account

  ## Example
      iex> %Request{}
      ...> |> Request.id(:financial_institution_id, "ad6fa583-2616-4a11-8b8d-eb98c53e2905")
      ...> |> Request.id(:financial_institution_user_id, "740b6ae8-a631-4a32-9afc-a5548ab99d7e")
      ...> |> Request.id(:financial_institution_account_id, "d9d60751-b741-4fa6-8524-8f9a066ca037")
      ...> |> FinancialInstitutionHolding.list
      %Ibanity.Collection[items: [Ibanity.FinancialInstitutionHolding{id: "44cd2dc8-163a-4dbe-b544-869e5f84ea54", ...}], ...]
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionHolding.list/1 instead"
  def list(%Request{} = request) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionHolding.list(request)
  end

  @doc """
  [Retrieves holding](https://documentation.ibanity.com/xs2a/api#get-financial-institution-holding)

  See `find/1`

  ## Example
      iex> %Request{}
      ...> |> FinancialInstitutionHolding.find(
      ...>  "ad6fa583-2616-4a11-8b8d-eb98c53e2905",
      ...>  "740b6ae8-a631-4a32-9afc-a5548ab99d7e",
      ...>  "d9d60751-b741-4fa6-8524-8f9a066ca037",
      ...>  "44cd2dc8-163a-4dbe-b544-869e5f84ea54"
      ...> )
      %{:ok, Ibanity.FinancialInstitutionHolding{id: "44cd2dc8-163a-4dbe-b544-869e5f84ea54", ...}}
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionHolding.find/5 instead"
  def find(
        %Request{} = request,
        financial_institution_id,
        financial_institution_user_id,
        financial_institution_account_id,
        financial_institution_holding_id
      ) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionHolding.find(
      request,
      financial_institution_id,
      financial_institution_user_id,
      financial_institution_account_id,
      financial_institution_holding_id
    )
  end

  @doc """
  [Retrieves holding](https://documentation.ibanity.com/xs2a/api#get-financial-institution-holding)

  Returns `{:ok, holding}` if successful, `{:error, reason}` otherwise

  ## Example
      iex> %Request{}
      ...> |> Request.id(:financial_institution_id, "ad6fa583-2616-4a11-8b8d-eb98c53e2905")
      ...> |> Request.id(:financial_institution_user_id, "740b6ae8-a631-4a32-9afc-a5548ab99d7e")
      ...> |> Request.id(:financial_institution_account_id, "d9d60751-b741-4fa6-8524-8f9a066ca037")
      ...> |> Request.id("83e440d7-6bfa-4b08-92b7-c2ae7fc5c0e9")
      ...> |> FinancialInstitutionHolding.find
      %{:ok, Ibanity.FinancialInstitutionHolding{id: "44cd2dc8-163a-4dbe-b544-869e5f84ea54", ...}}
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionHolding.find/1 instead"
  def find(%Request{} = request) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionHolding.find(request)
  end

  @doc """
  [Delete holding](https://documentation.ibanity.com/xs2a/api#delete-financial-institution-holding)

  See `delete/1`

  ## Example
      iex> %Request{}
      ...> |> FinancialInstitutionHolding.delete(
      ...>  "ad6fa583-2616-4a11-8b8d-eb98c53e2905",
      ...>  "740b6ae8-a631-4a32-9afc-a5548ab99d7e",
      ...>  "d9d60751-b741-4fa6-8524-8f9a066ca037",
      ...>  "83e440d7-6bfa-4b08-92b7-c2ae7fc5c0e9 "
      ...> )
      %{:ok, Ibanity.FinancialInstitutionHolding{id: "44cd2dc8-163a-4dbe-b544-869e5f84ea54", ...}}
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionHolding.delete/5 instead"
  def delete(
        %Request{} = request,
        financial_institution_id,
        financial_institution_user_id,
        financial_institution_account_id,
        financial_institution_holding_id
      ) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionHolding.delete(request,
      financial_institution_id,
      financial_institution_user_id,
      financial_institution_account_id,
      financial_institution_holding_id
    )
  end

  @doc """
  [Deletes holding](https://documentation.ibanity.com/xs2a/api#delete-financial-institution-holding)

  Returns `{:ok, holding}` if successful, `{:error, reason}` otherwise

  ## Example
      iex> %Request{}
      ...> |> Request.id(:financial_institution_id, "ad6fa583-2616-4a11-8b8d-eb98c53e2905")
      ...> |> Request.id(:financial_institution_user_id, "740b6ae8-a631-4a32-9afc-a5548ab99d7e")
      ...> |> Request.id(:financial_institution_account_id, "d9d60751-b741-4fa6-8524-8f9a066ca037")
      ...> |> Request.id("83e440d7-6bfa-4b08-92b7-c2ae7fc5c0e9")
      ...> |> FinancialInstitutionHolding.delete
      %{:ok, Ibanity.FinancialInstitutionHolding{id: "44cd2dc8-163a-4dbe-b544-869e5f84ea54", ...}}
  """
  @deprecated "Use Ibanity.Xs2a.Sandbox.FinancialInstitutionHolding.delete/1 instead"
  def delete(%Request{} = request) do
    Ibanity.Xs2a.Sandbox.FinancialInstitutionHolding.delete(request)
  end
end
