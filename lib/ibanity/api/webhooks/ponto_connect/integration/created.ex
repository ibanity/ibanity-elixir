defmodule Ibanity.Webhooks.PontoConnect.Integration.Created do
  @moduledoc """
  pontoConnect.integration.created webhook event
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
