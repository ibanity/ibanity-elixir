defmodule Ibanity.PontoConnect.RequestUtilsTest do
  use ExUnit.Case

  alias Ibanity.PontoConnect.RequestUtils
  alias Ibanity.Request

  describe "format_ids/1" do
    defmodule TestStruct do
      defstruct id: "123-test", something_else: "something"
    end

    test "returns a keyword list" do
      assert [key: _] = RequestUtils.format_ids(%{key: "value"})
    end

    test "puts id from a struct into the ID map" do
      test_struct = %TestStruct{}
      ids = %{test_id: test_struct}

      struct_id = test_struct.id
      assert [test_id: struct_id] == RequestUtils.format_ids(ids)
    end

    test "leaves other ids as they are" do
      ids = %{simple_id_string: "abc"}

      assert [simple_id_string: "abc"] == RequestUtils.format_ids(ids)
    end
  end

  describe "create_token_default_request/1" do
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

    test "returns a request for a client token request" do
      expected = %Request{
        attributes: %{
          grant_type: "client_credentials",
          client_id: "542cbc7a-7968-426c-830f-f9dc1c3c358a"
        },
        headers: [
          {:Authorization,
           "Basic NTQyY2JjN2EtNzk2OC00MjZjLTgzMGYtZjlkYzFjM2MzNThhOnRlc3QtY2xpZW50LXNlY3JldA=="},
          {:Accept, "application/json"},
          {:"Content-Type", "application/json"}
        ]
      }

      assert ^expected = RequestUtils.create_token_default_request(%Request{})
    end

    test "returns a request for a refresh token" do
      expected = %Request{
        attributes: %{
          grant_type: "refresh_token",
          client_id: "542cbc7a-7968-426c-830f-f9dc1c3c358a",
          refresh_token: "example-token"
        },
        headers: [
          {:Authorization,
           "Basic NTQyY2JjN2EtNzk2OC00MjZjLTgzMGYtZjlkYzFjM2MzNThhOnRlc3QtY2xpZW50LXNlY3JldA=="},
          {:Accept, "application/json"},
          {:"Content-Type", "application/json"}
        ]
      }

      request =
        [refresh_token: "example-token"]
        |> Request.attributes()

      assert ^expected = RequestUtils.create_token_default_request(request)
    end

    test "returns a request for an initial token" do
      expected = %Request{
        attributes: %{
          grant_type: "authorization_code",
          client_id: "542cbc7a-7968-426c-830f-f9dc1c3c358a",
          code: "example-code",
          redirect_uri: "https://example.com/oaut2/return",
          code_verifier: "pkce-code-verifier"
        },
        headers: [
          {:Authorization,
           "Basic NTQyY2JjN2EtNzk2OC00MjZjLTgzMGYtZjlkYzFjM2MzNThhOnRlc3QtY2xpZW50LXNlY3JldA=="},
          {:Accept, "application/json"},
          {:"Content-Type", "application/json"}
        ]
      }

      request =
        [
          code: "example-code",
          redirect_uri: "https://example.com/oaut2/return",
          code_verifier: "pkce-code-verifier"
        ]
        |> Request.attributes()

      assert ^expected = RequestUtils.create_token_default_request(request)
    end
  end

  describe "delete_token_default_request" do
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

    test "returns a request for revoking an access token" do
      expected =
        %Request{
          attributes: %{
            client_id: "542cbc7a-7968-426c-830f-f9dc1c3c358a"
          },
          headers: [
            {:Authorization,
             "Basic NTQyY2JjN2EtNzk2OC00MjZjLTgzMGYtZjlkYzFjM2MzNThhOnRlc3QtY2xpZW50LXNlY3JldA=="},
            {:Accept, "application/json"},
            {:"Content-Type", "application/json"}
          ]
        }

      assert ^expected = RequestUtils.delete_token_default_request(%Request{})
    end
  end
end
