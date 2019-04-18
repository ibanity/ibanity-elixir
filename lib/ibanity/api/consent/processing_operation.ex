defmodule Ibanity.Consent.ProcessingOperation do
  @moduledoc """
  """

  use Ibanity.Resource

  @api_schema_path  ~w(consent consent processingOperations)
  @revoke_api_schema_path ~w(consent consent processingOperations revocations)

  @resource_type "processing_operation"

  defstruct id: nil,
            business_domain: nil,
            revoked_at: nil,
            recurrent: nil,
            data_source_category: nil,
            data_source_host: nil,
            data_source_type: nil,
            data_source_reference: nil,
            it_service: nil,
            consent_id: nil,
            status: nil

  @doc """
  [Creates a processing operation].

  Returns `{:ok, processing_operation}` if successful, `{:error, reason}` otherwise.

  ## Example

      iex> [
      ...>   business_domain: "Legal",
      ...>   recurrent: true,
      ...>   ...
      ...> ]
      ...> |> Request.attributes
      ...> |> Request.id(:consent_id, "b5d6c5f9-e1d2-4cd1-a2aa-7baf964f7bf7")
      ...> |> ProcessingOperation.create
      {:ok, %Ibanity.Consent.ProcessingOperation{id: "270141aa-0c93-42a5-9adf-e2b9a8ab4cea"}}
  """
  def create(%Request{} = request) do
    request
    |> Request.resource_type(@resource_type)
    |> Client.execute(:post, @api_schema_path)
  end

  @doc """
  [Lists all processing operations belonging to a consent].

  Returns `{:ok, collection}` where `collection` is a `Ibanity.Collection` where items are of type `Ibanity.Consent.ProcessingOperation`,
  otherwise it returns `{:error, reason}`.

  ## Example

      iex> ProcessingOperation.list
      {:ok, %Ibanity.Collection{items: [%Ibanity.Consent.ProcessingOperation{...}], ...}
  """
  def list(%Request{} = request) do
    request
    |> Client.execute(:get, @api_schema_path)
  end

    @doc """
  [Revokes a processing operation].

  Returns `{:ok, processing_operation}` if successful, `{:error, reason}` otherwise.

  ## Example

      iex> [
      ...>   consent_id: "270141aa-0c93-42a5-9adf-e2b9a8ab4cea"
      ...>   id: "55c09df6-0bdd-46ef-8e66-e5297e0e8a7f"
      ...> ]
      ...> |> Request.ids
      ...> |> ProcessingOperation.revoke
      {:ok, %Ibanity.Consent.ProcessingOperation{id: "55c09df6-0bdd-46ef-8e66-e5297e0e8a7f"}}
  """
  def revoke(%Request{} = request) do
    request
    |> Client.execute(:post, @revoke_api_schema_path)
  end

  @doc false
  def key_mapping do
    [
      id: {~w(id), :string},
      business_domain: {~w(attributes data_subject), :string},
      revoked_at: {~w(attributes revoked_at), :datetime},
      recurrent: {~w(attributes recurrent), :boolean},
      data_source_category: {~w(attributes data_source_category), :string},
      data_source_host: {~w(attributes data_source_host), :string},
      data_source_type: {~w(attributes data_source_type), :string},
      data_source_reference: {~w(attributes data_source_reference), :string},
      it_service: {~w(attributes it_service), :string},
      status: {~w(attributes status), :string}
    ]
  end
end
