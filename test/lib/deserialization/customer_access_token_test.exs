defmodule Ibanity.CustomerAccessToken.DeserializationTest do
  use ExUnit.Case

  import Ibanity.JsonDeserializer

  test "deserializes the token and the id" do
    data = %{
      "attributes" => %{
        "token" => "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9..."
      },
      "id" => "595c6ace-4a22-4057-a49a-e4fd6ed5bce9",
      "type" => "customerAccessToken"
    }

    customer_access_token = deserialize(data, Ibanity.CustomerAccessToken)

    assert customer_access_token.id == "595c6ace-4a22-4057-a49a-e4fd6ed5bce9"
    assert customer_access_token.token == "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9..."
  end
end