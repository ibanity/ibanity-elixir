defmodule Ibanity.PontoConnect do
  @moduledoc """
  TODO
  """

  alias Ibanity.Request

  @doc """
  Adds default ponto connect attributes needed for a token request into attributes using the
  configured values, and sets the `%Request{}.customer_access_token` required for the authorization header.

  ## Examples

      iex> PontoConnect.token_default_request(%Request{})
      %Request{attributes: %{grant_type: "authorization_code", client_id: "542cbc7a-7968-426c-830f-f9dc1c3c358a"}}
  """
  def create_token_default_request(%Request{} = request) do
    new_attributes =
      %{
        client_id: client_id(request),
        grant_type: grant_type(request)
      }
      |> Map.merge(request.attributes)

    %Request{request | attributes: new_attributes}
    |> Request.header(:Authorization, "Basic " <> authorization_header(request))
  end

  defp grant_type(%{attributes: attributes}) do
    case attributes do
      %{refresh_token: _} ->
        "refresh_token"

      %{code: _} ->
        "authorization_code"

      _ ->
        "client_credentials"
    end
  end

  def delete_token_default_request(%Request{} = request) do
    new_attributes =
      %{
        client_id: client_id(request)
      }
      |> Map.merge(request.attributes)

    %Request{request | attributes: new_attributes}
    |> Request.header(:Authorization, "Basic " <> authorization_header(request))
  end

  defp authorization_header(request) do
    [client_id(request), client_secret(request)]
    |> Enum.join(":")
    |> Base.encode64()
  end

  defp client_secret(request) do
    Application.get_env(:ibanity, :applications, [])
    |> get_in([request.application, :ponto_connect_client_secret])
  end

  defp client_id(request) do
    Application.get_env(:ibanity, :applications, [])
    |> get_in([request.application, :ponto_connect_client_id])
  end
end
