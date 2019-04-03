defmodule Ibanity.Consent.Consent do
  @moduledoc """
  """

  use Ibanity.Resource

  @api_schema_path  ~w(consent consents)
  @validate_api_schema_path ~w(consent consents validations)

  @resource_type "consent"

  defstruct id: nil,
            validated_at: nil,
            revoked_at: nil,
            data_subject: nil,
            authorized_representative_type: nil,
            authorized_representative_reference: nil,
            data_controller_meta: nil,
            displayed_text: nil,
            action_type: nil,
            status: nil

  @doc """
  [Creates a consent].

  Returns `{:ok, consent}` if successful, `{:error, reason}` otherwise.

  ## Example

      iex> [
      ...>   action_type: "checkbox",
      ...>   displayed_text: "Your consent text.",
      ...>   ...
      ...> ]
      ...> |> Request.attributes
      ...> |> Consent.create
      {:ok, %Ibanity.Consent.Consent{id: "270141aa-0c93-42a5-9adf-e2b9a8ab4cea"}}
  """
  def create(%Request{} = request) do
    request
    |> Request.id(:id, "")
    |> Request.resource_type(@resource_type)
    |> Client.execute(:post, @api_schema_path)
  end

  @doc """
  [Validates a consent].

  Returns `{:ok, consent}` if successful, `{:error, reason}` otherwise.

  ## Example

      iex> [
      ...>   action_type: "https://fake-tpp.com/payment-initiated",
      ...>   displayed_text: "b57cca6b-74d6-4ac8-ba5d-4e28160d8dde",
      ...>   ...
      ...> ]
      ...> |> Request.attributes
      ...> |> Consent.create
      {:ok, %Ibanity.Consent.Consent{id: "270141aa-0c93-42a5-9adf-e2b9a8ab4cea"}}
  """
  def validate(consent_id) do
    Request.id(:consent_id, consent_id)
    |> Client.execute(:post, @validate_api_schema_path)
  end

  @doc false
  def key_mapping do
    [
      id: {~w(id), :string},
      validated_at: {~w(attributes validated_at), :datetime},
      revoked_at: {~w(attributes revoked_at), :datetime},
      data_subject: {~w(attributes data_subject), :string},
      authorized_representative_type: {~w(attributes authorized_representative_type), :string},
      authorized_representative_reference: {~w(attributes authorized_representative_reference), :string},
      data_controller_meta: {~w(attributes data_controller_meta), :string},
      displayed_text: {~w(attributes displayed_text), :string},
      action_type: {~w(attributes action_type), :string},
      status: {~w(attributes status), :string},
    ]
  end
end
