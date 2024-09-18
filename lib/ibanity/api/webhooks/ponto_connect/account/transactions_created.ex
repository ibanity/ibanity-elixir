defmodule Ibanity.Webhooks.PontoConnect.Account.TransactionsCreated do
  @moduledoc """
  pontoConnect.account.transactionsCreated webhook event
  """

  defstruct [
    :id,
    :created_at,
    :count,
    :account_id,
    :synchronization_id,
    :organization_id
  ]

  def key_mapping do
    [
      id: {~w(id), :string},
      created_at: {~w(attributes createdAt), :datetime},
      count: {~w(attributes count), :number},
      account_id: {~w(relationships account data id), :string},
      synchronization_id: {~w(relationships synchronization data id), :string},
      organization_id: {~w(relationships organization data id), :string}
    ]
  end
end
