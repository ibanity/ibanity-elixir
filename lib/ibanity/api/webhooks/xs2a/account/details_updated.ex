defmodule Ibanity.Webhooks.Xs2a.Account.DetailsUpdated do
  @moduledoc """
  xs2a.account.detailsUpdated webhook event
  """

  defstruct id: nil,
            created_at: nil,
            account_id: nil,
            synchronization_id: nil

  def key_mapping do
    [
      id: {~w(id), :string},
      created_at: {~w(attributes createdAt), :datetime},
      account_id: {~w(relationships account data id), :string},
      synchronization_id: {~w(relationships synchronization data id), :string}
    ]
  end
end
