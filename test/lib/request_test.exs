defmodule Ibanity.RequestTest do
  use ExUnit.Case

  alias Ibanity.Request

  describe ".header/3" do
    test "add a new header" do
      request =
        %Request{}
        |> Request.header(:"X-Http-Dummy", "foo")

      assert [:Accept, :"Content-Type", :"X-Http-Dummy"]
        |> Enum.all?(&(Keyword.has_key?(request.headers, &1)))
    end
  end

  describe ".header/2" do
    test "add a new header" do
      request = Request.header(:"X-Http-Dummy", "foo")

      assert [:Accept, :"Content-Type", :"X-Http-Dummy"]
        |> Enum.all?(&(Keyword.has_key?(request.headers, &1)))
    end
  end

  describe ".headers/3" do
    test "add multiple headers at once" do
      request =
        %Request{}
        |> Request.headers(["X-Http-Dummy": "foo", "X-Header": "bar"])

        assert [:Accept, :"Content-Type", :"X-Http-Dummy", :"X-Header"]
          |> Enum.all?(&(Keyword.has_key?(request.headers, &1)))
    end
  end

  describe ".idempotency_key/1" do
    test "set the key" do
      request =
        %Request{}
        |> Request.idempotency_key("6648301f-edb6-4260-aa5d-f9943c76eda9")

      assert request.idempotency_key == "6648301f-edb6-4260-aa5d-f9943c76eda9"
    end
  end

  describe ".has_customer_access_token?/1" do
    test "false when creating empty request" do
      refute Request.has_customer_access_token?(%Request{})
    end

    test "true when set" do
      token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
      request =
        %Request{}
        |> Request.customer_access_token(token)

      assert Request.has_customer_access_token?(request)
    end
  end
end
