defmodule Ibanity.Webhooks.PontoConnect.Integration.AccountRevoked do
  @moduledoc """
  pontoConnect.integration.accoRevoked webhook event
  """

  defstruct [
    :id,
    :created_at,
    :account_id,
    :organization_id
  ]

  def key_mapping do
    [
      id: {~w(id), :string},
      created_at: {~w(attributes createdAt), :datetime},
      account_id: {~w(relationships account data id), :string},
      organization_id: {~w(relationships organization data id), :string}
    ]
  end
end
