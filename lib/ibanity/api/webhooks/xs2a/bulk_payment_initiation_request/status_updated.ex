defmodule Ibanity.Webhooks.Xs2a.BulkPaymentInitiationRequest.StatusUpdated do
  @moduledoc """
  xs2a.bulkPaymentInitiationRequest.statusUpdated webhook event
  """

  defstruct id: nil,
            created_at: nil,
            status: nil,
            bulk_payment_initiation_request_id: nil

  def key_mapping do
    [
      id: {~w(id), :string},
      created_at: {~w(attributes createdAt), :datetime},
      status: {~w(attributes status), :string},
      bulk_payment_initiation_request_id:
        {~w(relationships bulkPaymentInitiationRequest data id), :string}
    ]
  end
end
