defmodule Ibanity.Webhooks.PontoConnect.PaymentRequest.Closed do
  @moduledoc """
  pontoConnect.paymentRequest.closed webhook event
  """

  defstruct [
    :id,
    :created_at,
    :account_id,
    :payment_request_id,
    :organization_id
  ]

  def key_mapping do
    [
      id: {~w(id), :string},
      created_at: {~w(attributes createdAt), :datetime},
      account_id: {~w(relationships account data id), :string},
      payment_request_id: {~w(relationships paymentRequest data id), :string},
      organization_id: {~w(relationships organization data id), :string}
    ]
  end
end
