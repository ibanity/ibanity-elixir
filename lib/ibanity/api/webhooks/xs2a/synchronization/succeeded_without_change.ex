defmodule Ibanity.Webhooks.Xs2a.Synchronization.SucceededWithoutChange do
  @moduledoc """
  xs2a.synchronization.succeededWithoutChange webhook event
  """

  defstruct id: nil,
            created_at: nil,
            synchronization_subtype: nil,
            account_id: nil,
            synchronization_id: nil

  def key_mapping do
    [
      id: {~w(id), :string},
      created_at: {~w(attributes createdAt), :datetime},
      synchronization_subtype: {~w(attributes synchronizationSubtype), :string},
      account_id: {~w(relationships account data id), :string},
      synchronization_id: {~w(relationships synchronization data id), :string}
    ]
  end
end
