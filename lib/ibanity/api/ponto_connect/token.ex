defmodule Ibanity.PontoConnect.Token do
  @moduledoc """
  [Tokem](https://documentation.ibanity.com/ponto-connect/2/api#token) API wrapper
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
  Requests an access or client token.

  All access token types provide a convenience function that does not require a request struct, but is limitted to
  the default application.

  ## Examples

  ### Request initial access token using the authorization code from user linking process

      iex> [
      ...>   code: "nwma9L6Ca_Hx_95RZNbYvZbf7bDuw-H7F1s0tiaYt1c.kd9X3R61y8KaEdFvYo_OMdZ5Ufm8EYbpxekYv0RlQRQ",
      ...>   redirect_uri: "https://fake-tpp.com/ponto-authorization",
      ...>   code_verifier: "71855516a563705a2f13e4a10375efa2a0e7584ed89accaa69"
      ...> ]
      ...> |> Request.attributes()
      ...> |> PontoConnect.Token.create()
      {:ok,
        %Ibanity.PontoConnect.Token{
          access_token: "W2AGp8iNGA4B8S8EKEAbCUAmAyNGmrqYGn3hHtlQ7yQ.FcuGgdGdzgc_2RJ3AopGSG5raqwjQxsc-sUQ76rBVmQ",
          expires_in: 1800,
          refresh_token: "_xzub81VSRzX_pujZEp8V7bauFRsxetJfsuI5ttComM.3w_ihqIUqfRmfIok6OzrdjPduxGINA32aZDhtNxdGV0",
          scope: "offline_access ai pi name",
          token_type: "bearer"
        }
      }

      iex> attrs = [
      ...>   code: "nwma9L6Ca_Hx_95RZNbYvZbf7bDuw-H7F1s0tiaYt1c.kd9X3R61y8KaEdFvYo_OMdZ5Ufm8EYbpxekYv0RlQRQ",
      ...>   redirect_uri: "https://fake-tpp.com/ponto-authorization",
      ...>   code_verifier: "71855516a563705a2f13e4a10375efa2a0e7584ed89accaa69"
      ...> ]
      iex> PontoConnect.Token.create(attrs)
      {:ok,
        %Ibanity.PontoConnect.Token{
          access_token: "W2AGp8iNGA4B8S8EKEAbCUAmAyNGmrqYGn3hHtlQ7yQ.FcuGgdGdzgc_2RJ3AopGSG5raqwjQxsc-sUQ76rBVmQ",
          expires_in: 1800,
          refresh_token: "_xzub81VSRzX_pujZEp8V7bauFRsxetJfsuI5ttComM.3w_ihqIUqfRmfIok6OzrdjPduxGINA32aZDhtNxdGV0",
          scope: "offline_access ai pi name",
          token_type: "bearer"
        }
      }

  ### Request access token using the refresh token

      iex> [refresh_token: "JAuojyAZmuga8giR0hc-xbzXUSXaLzrnj1adUAhr5V8.M7byqLdx2QAApy3qrTecoGMC3egoceNw8K3GYnycsZA"]
      ...> |> Request.attributes()
      ...> |> PontoConnect.Token.create()
      {:ok,
        %Ibanity.PontoConnect.Token{
          access_token: "6Rtxx0QUw0OYIKWQgAGIiyJWsrIVFXxatG_JdlCDdK0.6UA7brX3ym1Rnwpz-6RorRbe1XuL239lSdTdUMaABz0",
          expires_in: 1799,
          refresh_token: "n6zVPhKrQiixID9nbWFo-QCUwHteR1lgggz3HTwY9mA.5TqNprnFZWCrpvnkxxIvoOBvNaQ2UdMSr3YNpT1kVf4",
          scope: "offline_access ai pi name",
          token_type: "bearer"
        }
      }

      iex> [refresh_token: "JAuojyAZmuga8giR0hc-xbzXUSXaLzrnj1adUAhr5V8.M7byqLdx2QAApy3qrTecoGMC3egoceNw8K3GYnycsZA"]
      ...> |> PontoConnect.Token.create()
      {:ok,
        %Ibanity.PontoConnect.Token{
          access_token: "6Rtxx0QUw0OYIKWQgAGIiyJWsrIVFXxatG_JdlCDdK0.6UA7brX3ym1Rnwpz-6RorRbe1XuL239lSdTdUMaABz0",
          expires_in: 1799,
          refresh_token: "n6zVPhKrQiixID9nbWFo-QCUwHteR1lgggz3HTwY9mA.5TqNprnFZWCrpvnkxxIvoOBvNaQ2UdMSr3YNpT1kVf4",
          scope: "offline_access ai pi name",
          token_type: "bearer"
        }
      }

  ### Request client access token

      iex> PontoConnect.Token.create(%Request{})
      {:ok,
        %Ibanity.PontoConnect.Token{
          access_token: "ryAs9Cpd6RqqibYNyUMGVZ-VnjUjE6LC3aGK_jBmTms.vN5ZRfvsaeiaJAP3euTQGUk_LzO7LFmukFPjf9lJ1B4",
          expires_in: 1799,
          scope: "",
          token_type: "bearer"
        }
      }

      iex> PontoConnect.Token.create()
      {:ok,
        %Ibanity.PontoConnect.Token{
          access_token: "ryAs9Cpd6RqqibYNyUMGVZ-VnjUjE6LC3aGK_jBmTms.vN5ZRfvsaeiaJAP3euTQGUk_LzO7LFmukFPjf9lJ1B4",
          expires_in: 1799,
          scope: "",
          token_type: "bearer"
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
  Convenience function to receive a new token using a `%Ibanity.PontoConnect.Token{}` struct.

  Equivalent to

      iex> attrs = [refresh_token: token.refresh_token]
      iex> %Ibanity.Request{} |> Request.attributes(attrs) |> PontoConnect.Token.create()
      {:ok, %PontoConnect.Token{}}

  ## Examples

      iex> valid_attrs = [
      ...>   code: "nwma9L6Ca_Hx_95RZNbYvZbf7bDuw-H7F1s0tiaYt1c.kd9X3R61y8KaEdFvYo_OMdZ5Ufm8EYbpxekYv0RlQRQ",
      ...>   redirect_uri: "https://fake-tpp.com/ponto-authorization",
      ...>   code_verifier: "71855516a563705a2f13e4a10375efa2a0e7584ed89accaa69"
      ...> ]
      iex> {:ok, token} = PontoConnect.Token.create(valid_attrs)
      iex> PontoConnect.Token.refresh(token)
      {:ok, %PontoConnect.Token{}}
  """
  def refresh(%__MODULE__{} = token) do
    token.application
    |> Request.application()
    |> Request.attributes(refresh_token: token.refresh_token)
    |> create()
  end

  @doc """
  [Revoke Refresh Token](https://documentation.ibanity.com/ponto-connect/2/api#revoke-refresh-token)

  ## Example

      iex> [token: "H1Sc-bFi3946Xzca5yuUMZDjVz6WuZ061Hkt3V_lpWs.8wJzYLM8vx1ONzaYlMHcCl_OM_nPOzDGcuCAQPqKPAc"]
      ...> |> Request.attributes()
      ...> PontoConnect.Token.delete()
      {:ok, %{}}
  """
  def delete(attrs) when is_list(attrs) do
    attrs
    |> Request.attributes()
    |> delete()
  end

  def delete(%Request{attributes: %{token: refresh_token}} = request)
      when not is_nil(refresh_token) do
    request
    |> Request.resource_type(__MODULE__)
    |> PontoConnect.RequestUtils.delete_token_default_request()
    |> Client.execute_basic(:post, @api_schema_delete_path)
  end

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
