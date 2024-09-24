defmodule Ibanity.PontoConnect.Token do
  @moduledoc """
  [Token](https://documentation.ibanity.com/ponto-connect/2/api#token) API wrapper
  """

  use Ibanity.Resource

  alias Ibanity.PontoConnect

  defstruct [
    :access_token,
    :expires_in,
    :refresh_token,
    :scope,
    :issued_at,
    token_type: "bearer",
    application: :default
  ]

  @api_schema_path ["ponto-connect", "oauth2", "token"]
  @api_schema_delete_path ["ponto-connect", "oauth2", "revoke"]

  @doc """
  Requests an access or client token, or a new token from a refresh token.

  All access token types provide a convenience function that does not require a request struct, but is limitted to
  the `:default` application.

  ## Examples

  Request **Initial Access Token** using the authorization code and code verifier from the user linking process

      iex> [
      ...>   code: "nwma9L6Ca_Hx_95RZNbYvZbf7bDuw-H7F1s0tiaYt1c.kd9X3R61y8KaEdFvYo_OMdZ5Ufm8EYbpxekYv0RlQRQ",
      ...>   redirect_uri: "https://fake-tpp.com/ponto-authorization",
      ...>   code_verifier: "71855516a563705a2f13e4a10375efa2a0e7584ed89accaa69"
      ...> ]
      ...> |> Ibanity.Request.attributes()
      ...> |> Ibanity.Request.application(:my_application)
      ...> |> Ibanity.PontoConnect.Token.create()
      {:ok,
        %Ibanity.PontoConnect.Token{
          access_token: "qOYqfBqFHQ8dzEgayUEpWOoU3r6A3AjYSgMr5FMOcH4.UGkNelkyrgZgmfsasI-qYSJ5iyl570rodsSgZtxkdzI",
          expires_in: 1799,
          refresh_token: "6_-XgJvLqa7gF6pRl10pfMCr3EUPMlxN7rsiclGWugo.8uowPzwsyPNzkhlJw_UR3ZZ2-zCpw1Tksn2GQK_cJoI",
          scope: "offline_access ai pi name",
          issued_at: ~U[2024-09-19 12:52:00.229666Z],
          token_type: "bearer",
          application: :default
        }
      }

  Request access token using the **Refresh Token**

      iex> [refresh_token: "JAuojyAZmuga8giR0hc-xbzXUSXaLzrnj1adUAhr5V8.M7byqLdx2QAApy3qrTecoGMC3egoceNw8K3GYnycsZA"]
      ...> |> Ibanity.Request.attributes()
      ...> |> Ibanity.Request.application(:my_application)
      ...> |> Ibanity.PontoConnect.Token.create()
      {:ok,
        %Ibanity.PontoConnect.Token{
          access_token: "qOYqfBqFHQ8dzEgayUEpWOoU3r6A3AjYSgMr5FMOcH4.UGkNelkyrgZgmfsasI-qYSJ5iyl570rodsSgZtxkdzI",
          expires_in: 1799,
          refresh_token: "6_-XgJvLqa7gF6pRl10pfMCr3EUPMlxN7rsiclGWugo.8uowPzwsyPNzkhlJw_UR3ZZ2-zCpw1Tksn2GQK_cJoI",
          scope: "offline_access ai pi name",
          issued_at: ~U[2024-09-19 12:52:00.229666Z],
          token_type: "bearer",
          application: :default
        }
      }

  Request **Client Access Token**

      iex> :my_application
      ...> Ibanity.Request.application()
      ...> Ibanity.PontoConnect.Token.create()
      {:ok,
        %Ibanity.PontoConnect.Token{
          access_token: "TCgfyT_O9QVTwTbqW9kM7RgHpJDg2g9l1YRTgHRvMy8.CHiN7_tbwv-8w3hJXXnf0CO7KO_IoPsGSbanXNvOi-8",
          expires_in: 1799,
          refresh_token: nil,
          scope: "",
          issued_at: ~U[2024-09-19 12:55:13.118113Z],
          token_type: "bearer",
          application: :default
        }
      }
  """
  def create(request_or_attributes \\ %Request{})

  def create(attrs) when is_list(attrs) do
    attrs
    |> Request.attributes()
    |> create()
  end

  def create(%Request{} = request) do
    request
    |> Request.resource_type(__MODULE__)
    |> PontoConnect.RequestUtils.create_token_default_request()
    |> Client.execute_basic(:post, @api_schema_path)
    |> put_application(request.application)
  end

  defp put_application({:ok, %__MODULE__{} = token}, application),
    do: {:ok, %__MODULE__{token | application: application}}

  defp put_application(response, _application), do: response

  @doc """
  Convenience function to receive a new token using a `%Ibanity.PontoConnect.Token{}` struct,
  equivalent to using `create/1` with the `:refresh_token` attribute.

  Note: `refresh/1` only works for access tokens with a `:refresh_token` (needs scope `"offline_access"`)

  Equivalent to

      iex> [refresh_token: token.refresh_token]
      ...> |> Ibanity.Request.attributes()
      ...> |> Ibanity.Request.application(:my_application)
      ...> |> Ibanity.PontoConnect.Token.create()
      {:ok, %Ibanity.PontoConnect.Token{}}

  ## Examples

      iex> attrs = [
      ...>   code: "nwma9L6Ca_Hx_95RZNbYvZbf7bDuw-H7F1s0tiaYt1c.kd9X3R61y8KaEdFvYo_OMdZ5Ufm8EYbpxekYv0RlQRQ",
      ...>   redirect_uri: "https://fake-tpp.com/ponto-authorization",
      ...>   code_verifier: "71855516a563705a2f13e4a10375efa2a0e7584ed89accaa69"
      ...> ]
      iex> {:ok, token} = Ibanity.PontoConnect.Token.create(attrs)
      iex> Ibanity.PontoConnect.Token.refresh(token)
      {:ok, %Ibanity.PontoConnect.Token{}}
  """
  def refresh(%__MODULE__{} = token) do
    token.application
    |> Request.application()
    |> Request.attributes(refresh_token: token.refresh_token)
    |> create()
  end

  @doc """
  [Revoke Refresh Token](https://documentation.ibanity.com/ponto-connect/2/api#revoke-refresh-token)

  ## Examples

  With refresh token as string

      iex> [token: "H1Sc-bFi3946Xzca5yuUMZDjVz6WuZ061Hkt3V_lpWs.8wJzYLM8vx1ONzaYlMHcCl_OM_nPOzDGcuCAQPqKPAc"]
      ...> |> Ibanity.Request.attributes()
      ...> |> Ibanity.Request.application(:my_application)
      ...> Ibanity.PontoConnect.Token.delete()
      {:ok, %{}}

  With token struct

    iex> Ibanity.PontoConnect.Token.delete(token)
    {:ok, %{}}
  """
  def delete(attrs) when is_list(attrs) do
    attrs
    |> Request.attributes()
    |> delete()
  end

  def delete(%__MODULE__{} = token) do
    [token: token.refresh_token]
    |> Request.attributes()
    |> Request.application(token.application)
    |> delete()
  end

  def delete(%Request{attributes: %{token: token}} = request)
      when not is_nil(token) do
    request
    |> Request.resource_type(__MODULE__)
    |> PontoConnect.RequestUtils.delete_token_default_request()
    |> Client.execute_basic(:post, @api_schema_delete_path)
  end

  @doc """
  Convenience function to determine if a token is expired.

  Note: The result is based on the UTC datetime of when the token was received, so it will be off
  by the transfer time + processing time (up to 1 second).

  ## Example
      iex> {:ok, token} = Ibanity.PontoConnect.Token.create()
      iex> Ibanity.PontoConnect.Token.expired?(token)
      false
  """
  def expired?(%__MODULE__{issued_at: issued_at, expires_in: expires_in}) do
    expiration_dt = DateTime.add(issued_at, expires_in)
    now = DateTime.utc_now()

    DateTime.before?(expiration_dt, now)
  end

  @doc false
  def key_mapping do
    [
      access_token: {~w(access_token), :string},
      expires_in: {~w(expires_in), :integer},
      refresh_token: {~w(refresh_token), :string},
      scope: {~w(scope), :string},
      token_type: {~w(token_type), :string},
      issued_at: {fn _ -> DateTime.utc_now() end, :function}
    ]
  end
end
