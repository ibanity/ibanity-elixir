defmodule Ibanity.Webhooks.PontoConnect.Account.DetailsUpdated do
  @moduledoc """
  pontoConnect.account.detailsUpdated webhook event
  """

  defstruct [
    :id,
    :created_at,
    :account_id,
    :synchronization_id,
    :organization_id
  ]

  def key_mapping do
    [
      id: {~w(id), :string},
      created_at: {~w(attributes createdAt), :datetime},
      account_id: {~w(relationships account data id), :string},
      synchronization_id: {~w(relationships synchronization data id), :string},
      organization_id: {~w(relationships organization data id), :string}
    ]
  end
end
