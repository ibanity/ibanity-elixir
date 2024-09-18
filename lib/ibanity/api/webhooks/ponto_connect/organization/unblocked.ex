defmodule Ibanity.Webhooks.PontoConnect.Account.Unblocked do
  @moduledoc """
  pontoConnect.account.unblocked webhook event
  """

  defstruct [
    :id,
    :created_at,
    :organization_id
  ]

  def key_mapping do
    [
      id: {~w(id), :string},
      created_at: {~w(attributes createdAt), :datetime},
      organization_id: {~w(relationships organization data id), :string}
    ]
  end
end
