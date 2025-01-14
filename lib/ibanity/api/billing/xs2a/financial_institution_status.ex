defmodule Ibanity.Billing.Xs2a.FinancialInstitutionStatus do
  use Ibanity.Resource

  @api_schema_path ~w(billing xs2a financialInstitutionStatuses)

  defstruct id: nil,
            worst_status: nil,
            best_status: nil

  def list(%Request{} = request),
    do: Client.execute(request, :get, @api_schema_path, "financialInstitutionStatus")

  def key_mapping do
    [
      id: {~w(id), :string},
      worst_status: {~w(attributes status worst), :string},
      best_status: {~w(attributes status best), :string}
    ]
  end
end
