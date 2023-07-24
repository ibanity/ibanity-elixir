defmodule Ibanity.Webhooks.Xs2a.PaymentInitiationRequest.AuthorizationCompleted do
  @moduledoc """
  xs2a.paymentInitiationRequest.authorizationCompleted webhook event
  """

  defstruct id: nil,
            created_at: nil,
            status: nil,
            payment_initiation_request_id: nil

  def key_mapping do
    [
      id: {~w(id), :string},
      created_at: {~w(attributes createdAt), :datetime},
      status: {~w(attributes status), :string},
      payment_initiation_request_id: {~w(relationships paymentInitiationRequest data id), :string}
    ]
  end
end
