defmodule Ibanity.Webhooks.PontoConnect.Synchronization.SucceededWithoutChange do
  @moduledoc """
  pontoConnect.synchronization.succeededWithoutChange webhook event
  """

  defstruct [
    :id,
    :created_at,
    :synchronization_subtype,
    :account_id,
    :synchronization_id,
    :organization_id
  ]

  def key_mapping do
    [
      id: {~w(id), :string},
      created_at: {~w(attributes createdAt), :datetime},
      synchronization_subtype: {~w(attributes synchronizationSubtype), :string},
      account_id: {~w(relationships account data id), :string},
      synchronization_id: {~w(relationships synchronization data id), :string},
      organization_id: {~w(relationships organization data id), :string}
    ]
  end
end
