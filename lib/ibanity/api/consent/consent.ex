defmodule Ibanity.Consent.Consent do
  @moduledoc """
  """

  use Ibanity.Resource

  @api_schema_path  ~w(consent consents)
  @validate_api_schema_path ~w(consent consent validations)
  @revoke_api_schema_path ~w(consent consent revocations)

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
            action_date: nil,
            terms_reference: nil,
            terms_version: nil,
            status: nil

  def list(%Request{} = request) do
    request
    |> Request.id(:id, "")
    |> Client.execute(:get, @api_schema_path)
  end

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
  [Finds a consent].

  Returns `{:ok, consent}` if successful, `{:error, reason}` otherwise.

  ## Example

      iex> "270141aa-0c93-42a5-9adf-e2b9a8ab4cea"
      ...> |> Request.id
      ...> |> Consent.find
      {:ok, %Ibanity.Consent.Consent{id: "270141aa-0c93-42a5-9adf-e2b9a8ab4cea"}}
  """
  def find(%Request{} = request) do
    request
    |> Client.execute(:get, @api_schema_path)
  end

  @doc """
  [Validates a consent].

  Returns `{:ok, consent}` if successful, `{:error, reason}` otherwise.

  ## Example

      iex> [
      ...>   consent_id: "270141aa-0c93-42a5-9adf-e2b9a8ab4cea"
      ...> ]
      ...> |> Request.ids
      ...> |> Consent.validate
      {:ok, %Ibanity.Consent.Consent{id: "270141aa-0c93-42a5-9adf-e2b9a8ab4cea"}}
  """
  def validate(%Request{} = request) do
    request
    |> Client.execute(:post, @validate_api_schema_path)
  end

  @doc """
  [Revokes a consent].

  Returns `{:ok, consent}` if successful, `{:error, reason}` otherwise.

  ## Example

      iex> [
      ...>   consent_id: "270141aa-0c93-42a5-9adf-e2b9a8ab4cea"
      ...> ]
      ...> |> Request.ids
      ...> |> Consent.revoke
      {:ok, %Ibanity.Consent.Consent{id: "270141aa-0c93-42a5-9adf-e2b9a8ab4cea"}}
  """
  def revoke(%Request{} = request) do
    request
    |> Client.execute(:post, @revoke_api_schema_path)
  end

  @doc false
  def key_mapping do
    [
      id: {~w(id), :string},
      validated_at: {~w(attributes validatedAt), :datetime},
      revoked_at: {~w(attributes revokedAt), :datetime},
      data_subject: {~w(attributes dataSubject), :string},
      authorized_representative_type: {~w(attributes authorizedRepresentativeType), :string},
      authorized_representative_reference: {~w(attributes authorizedRepresentativeReference), :string},
      data_controller_meta: {~w(attributes dataControllerMeta), :string},
      displayed_text: {~w(attributes displayedText), :string},
      action_type: {~w(attributes actionType), :string},
      terms_reference: {~w(attributes termsReference), :string},
      terms_version: {~w(attributes termsVersion), :string},
      status: {~w(attributes status), :string},
    ]
  end
end
