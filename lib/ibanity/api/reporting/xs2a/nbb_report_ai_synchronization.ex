defmodule Ibanity.Reporting.Xs2a.NbbReportAiSynchronization do
  use Ibanity.Resource

  @api_schema_path ~w(reporting xs2a customer nbbReportAiSynchronization)

  defstruct account_reference_hash: nil,
            aspsp_name: nil,
            aspsp_type: nil,
            external_customer_id_hash: nil,
            region: nil,
            type: nil,
            occurred_at: nil

  def find(%Request{} = request) do
    request
    |> Client.execute(:get, @api_schema_path)
  end

  def key_mapping do
    [
      account_reference_hash: {~w(attributes accountReferenceHash), :string},
      aspsp_name: {~w(attributes aspspName), :string},
      aspspType: {~w(attributes aspspType), :string},
      external_customer_id_hash: {~w(attributes externalCustomerIdHash), :string},
      region: {~w(attributes region), :string},
      type: {~w(attributes type), :string},
      occurred_at: {~w(attributes occurredAt), :string}
    ]
  end
end
