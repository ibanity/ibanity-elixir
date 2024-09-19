defmodule Ibanity.PontoConnect.RequestUtils do
  @moduledoc false

  alias Ibanity.Request

  @doc false
  def format_ids(ids) do
    for {key, val} <- ids, val != nil do
      case val do
        %{id: id} -> {key, id}
        _ -> {key, val}
      end
    end
  end

  @doc false
  def token_argument_error_msg(resource_name, other) do
    """
    Cannot access #{resource_name} with given arguments.
    Expected one of:
    - `%Ibanity.Request{}` with `:token` set
    - `%Ibanity.PontoConnect.Token{}`

    Got: #{inspect(other)}
    """
  end

  @doc false
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

  @doc false
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
