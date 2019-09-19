defmodule Ibanity.Billing.Xs2a.Report do
  use Ibanity.Resource

  @api_schema_path ~w(billing xs2a customer report)

  defstruct beginning: nil,
            end: nil,
            active_accounts_count: nil,
            inactive_accounts_count: nil,
            payment_initiation_requests_count: nil,
            account_transactions_synchronization_count: nil,
            account_details_synchronization_count: nil,
            accounts_count: nil

  def find(%Request{} = request) do
    request
    |> Client.execute(:get, @api_schema_path)
  end

  def key_mapping do
    [
      beginning: {~w(attributes billingPeriod beginning), :datetime},
      end: {~w(attributes billingPeriod end), :datetime},
      active_accounts_count: {~w(attributes billingPeriod activeAccountsCount), :integer},
      inactive_accounts_count: {~w(attributes billingPeriod inactiveAccountsCount), :integer},
      payment_initiation_requests_count: {~w(attributes billingPeriod paymentInitiationRequestsCount), :integer},
      account_transactions_synchronization_count: {~w(attributes billingPeriod accountTransactionsSynchronizationCount), :integer},
      account_details_synchronization_count: {~w(attributes billingPeriod accountDetailsSynchronizationCount), :integer},
      accounts_count: {~w(attributes billingPeriod accountsCount), :integer}
    ]
  end
end
