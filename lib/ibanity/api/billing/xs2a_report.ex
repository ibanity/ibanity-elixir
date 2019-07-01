defmodule Ibanity.Billing.Xs2aReport do
  use Ibanity.Resource

  @api_schema_path ~w(billing customer xs2aReport)

  defstruct new_active_deleted_accounts_count: nil,
            existing_inactive_deleted_accounts_count: nil,
            end: nil,
            billable_inactive_accounts_count: nil,
            billable_active_accounts_count: nil,
            beginning: nil

  def find(%Request{} = request) do
    request
    |> Client.execute(:get, @api_schema_path)
  end

  def key_mapping do
    [
      new_active_deleted_accounts_count: {~w(attributes newActiveDeletedAccountsCount), :integer},
      existing_inactive_deleted_accounts_count: {~w(attributes existingInactiveDeletedAccountsCount), :integer},
      end: {~w(attributes end), :datetime},
      billable_inactive_accounts_count: {~w(attributes billableInactiveAccountsCount), :integer},
      billable_active_accounts_count: {~w(attributes billableActiveAccountsCount), :integer},
      beginning: {~w(attributes beginning), :datetime}
    ]
  end
end
