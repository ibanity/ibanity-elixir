defmodule Ibanity.Reporting.Xs2a.NbbReportAiSynchronization do
  use Ibanity.Resource

  @api_schema_path ~w(reporting xs2a customer nbbReportAiSynchronization)

  defstruct accountReferenceHash: nil,
            aspspName: nil,
            aspspType: nil,
            externalCustomerIdHash: nil,
            region: nil,
            type: nil

  def find(%Request{} = request) do
    request
    |> Client.execute(:get, @api_schema_path)
  end

  def key_mapping do
    [
      accountReferenceHash: {~w(attributes accountReferenceHash), :datetime},
      aspspName: {~w(attributes aspspName), :datetime},
      aspspType: {~w(attributes aspspType), :string},
      externalCustomerIdHash: {~w(attributes externalCustomerIdHash), :integer},
      region: {~w(attributes region), :string},
      type: {~w(attributes type), :string}
  end
end
