defmodule Ibanity.Webhooks.Xs2a.PeriodicPaymentInitiationRequest.StatusUpdated do
  @moduledoc """
  xs2a.periodicPaymentInitiationRequest.statusUpdated webhook event
  """

  defstruct id: nil,
            created_at: nil,
            status: nil,
            periodic_payment_initiation_request_id: nil

  def key_mapping do
    [
      id: {~w(id), :string},
      created_at: {~w(attributes createdAt), :datetime},
      status: {~w(attributes status), :string},
      periodic_payment_initiation_request_id: {~w(relationships periodicPaymentInitiationRequest data id), :string}
    ]
  end
end
