defmodule Ibanity.PontoConnect do
  @moduledoc """
  TODO
  """

  alias Ibanity.Request

  @doc """
  Adds default ponto connect attributes needed for a token request into attributes using the
  configured values, and sets the required headers.

  This function needs the Ponto Connect configuration to be set correctly for the application used:

      config :ibanity,
        api_url: System.get_env("IBANITY_API_URL"),
        applications: [
          default: [
            ...
            ponto_connect_client_id: System.get_env("PONTO_CONNECT_CLIENT_ID"),
            ponto_connect_client_secret: System.get_env("PONTO_CONNECT_CLIENT_SECRET")
          ]
        ]

  and the `%Request{}` struct has to be set up with the correct attributes for the intended token.

  ## Examples

  ### Client token

      iex> PontoConnect.create_token_default_request(%Request{})
      %Request{
        attributes: %{
          grant_type: "client_credentials",
          client_id: "542cbc7a-7968-426c-830f-f9dc1c3c358a"
        },
        headers: [
          {:Authorization, "Basic NTQyY2JjN2EtNzk2OC00MjZjLTgzMGYtZjlkYzFjM2MzNThhOnRlc3QtY2xpZW50LXNlY3JldA=="},
          {:Accept, "application/json"},
          {:"Content-Type", "application/json"}
        ]
      }

  ### Refresh token

      iex> [refresh_token: "example-token"]
      ...> |> Request.attributes()
      ...> |> PontoConnect.create_token_default_request()
      %Request{
        attributes: %{
          grant_type: "refresh_token", 
          client_id: "542cbc7a-7968-426c-830f-f9dc1c3c358a",
          refresh_token: "example-token"
        },
        headers: [
          {:Authorization, "Basic NTQyY2JjN2EtNzk2OC00MjZjLTgzMGYtZjlkYzFjM2MzNThhOnRlc3QtY2xpZW50LXNlY3JldA=="},
          {:Accept, "application/json"},
          {:"Content-Type", "application/json"}
        ]
      }

  ### Initial token

      iex> [code: "example-code", redirect_uri: "https://example.com/oaut2/return", code_verifier: "pkce-code-verifier"]
      ...> |> Request.attributes()
      ...> |> PontoConnect.create_token_default_request()
      %Request{
        attributes: %{
          grant_type: "authorization_code",
          client_id: "542cbc7a-7968-426c-830f-f9dc1c3c358a",
          code: "example-code",
          redirect_uri: "https://example.com/oaut2/return",
          code_verifier: "pkce-code-verifier"
        },
        headers: [
          {:Authorization, "Basic NTQyY2JjN2EtNzk2OC00MjZjLTgzMGYtZjlkYzFjM2MzNThhOnRlc3QtY2xpZW50LXNlY3JldA=="},
          {:Accept, "application/json"},
          {:"Content-Type", "application/json"}
        ]
      }
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

  @doc """
  Adds default ponto connect attributes needed for a revoke token request into attributes using the
  configured values, and sets the required headers.

  This function needs the Ponto Connect configuration to be set correctly for the application used:

  config :ibanity,
  api_url: System.get_env("IBANITY_API_URL"),
  applications: [
    default: [
      ...
      ponto_connect_client_id: System.get_env("PONTO_CONNECT_CLIENT_ID"),
      ponto_connect_client_secret: System.get_env("PONTO_CONNECT_CLIENT_SECRET")
    ]
  ]

  ## Examples

  iex> PontoConnect.delete_token_default_request(%Request{})
  %Request{
    attributes: %{
      client_id: "542cbc7a-7968-426c-830f-f9dc1c3c358a"
    },
    headers: [
      {:Authorization, "Basic NTQyY2JjN2EtNzk2OC00MjZjLTgzMGYtZjlkYzFjM2MzNThhOnRlc3QtY2xpZW50LXNlY3JldA=="},
      {:Accept, "application/json"},
      {:"Content-Type", "application/json"}
    ]
  }
  """
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

  @doc false
  def token_argument_error_msg(resource_name, other) do
    """
    Cannot access #{resource_name} with given arguments.
    Expected one of:
    - `%Ibanity.Request{}` with `:customer_access_token` set
    - `%Ibanity.PontoConnect.Token{}`

    Got: #{inspect(other)}
    """
  end

  @doc false
  def format_ids(ids) do
    for {key, val} <- ids, val != nil do
      case val do
        %{id: id} -> {key, id}
        _ -> {key, val}
      end
    end
  end
end
