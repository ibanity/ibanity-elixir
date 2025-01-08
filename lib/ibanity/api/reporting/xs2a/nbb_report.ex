defmodule Ibanity.Reporting.Xs2a.NbbReport do
  use Ibanity.Resource

  @api_schema_path ~w(reporting xs2a customer nbbReport)

  defstruct beginning: nil,
            end: nil,
            account_information_accounts: nil,
            account_information_synchronization_count: nil,
            payment_initiation_accounts: nil,
            payment_initiations: nil

  def find(%Request{} = request) do
    request
    |> Client.execute(:get, @api_schema_path)
  end

  def key_mapping do
    [
      beginning: {~w(attributes beginning), :datetime},
      end: {~w(attributes end), :datetime},
      account_information_accounts: {~w(attributes accountInformationAccounts), :string},
      account_information_synchronization_count:
        {~w(attributes accountInformationSynchronizationCount), :string},
      payment_initiation_accounts: {~w(attributes paymentInitiationAccounts), :string},
      payment_initiations: {~w(attributes paymentInitiations), :string}
    ]
  end
end
