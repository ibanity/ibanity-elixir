defmodule Ibanity.PontoConnectTest do
  use ExUnit.Case
  alias Ibanity.{PontoConnect, Request}

  setup do
    apps_env = Application.get_env(:ibanity, :applications)

    new_apps_env =
      Keyword.update!(apps_env, :default, fn current_env ->
        [
          ponto_connect_client_id: "542cbc7a-7968-426c-830f-f9dc1c3c358a",
          ponto_connect_client_secret: "test-client-secret"
        ]
        |> Keyword.merge(current_env)
      end)

    Application.put_env(:ibanity, :applications, new_apps_env)
  end

  doctest Ibanity.PontoConnect
end
