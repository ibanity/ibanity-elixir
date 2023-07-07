defmodule Ibanity.Webhooks.Xs2a.Account.TransactionsDeleted do
  @moduledoc """
  xs2a.account.transactionsDeleted webhook event
  """

  defstruct id: nil,
            created_at: nil,
            count: nil,
            deleted_before: nil,
            account_id: nil

  def key_mapping do
    [
      id: {~w(id), :string},
      created_at: {~w(attributes createdAt), :datetime},
      count: {~w(attributes count), :integer},
      deleted_befoe: {~w(attributes deletedBefore), :datetime},
      account_id: {~w(relationships account data id), :string}
    ]
  end
end
