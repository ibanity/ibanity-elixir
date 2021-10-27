defmodule Ibanity.Webhooks.Xs2a.Synchronization.TransactionsCreated do
  @moduledoc """
  xs2a.synchronization.transactionsCreated webhook event
  """

  defstruct id: nil,
            created_at: nil,
            count: nil,
            account_id: nil,
            synchronization_id: nil

  def key_mapping do
    [
      id: {~w(id), :string},
      created_at: {~w(attributes createdAt), :datetime},
      count: {~w(attributes count), :integer},
      account_id: {~w(relationships account data id), :string},
      synchronization_id: {~w(relationships synchronization data id), :string}
    ]
  end
end
