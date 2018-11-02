defmodule Ibanity.RequestTest do
  use ExUnit.Case

  alias Ibanity.{CustomerAccessToken, Request}

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

  describe ".customer_access_token/2" do
    test "set the token when passing a CustomerAccessToken" do
      customer_access = %CustomerAccessToken{token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."}
      request =
        %Request{}
        |> Request.customer_access_token(customer_access)

      assert request.customer_access_token == "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
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

  describe ".id/3" do
    test "add an id to the existing ids" do
      request =
        %Request{resource_ids: [customerId: "f51e3418-ff16-44d4-a081-a932d882dd18"]}
        |> Request.id(:financialInstitutionId, "3eff5ae1-547b-464a-bac8-da971c7a0a05")

      assert [:customerId, :financialInstitutionId]
        |> Enum.all?(&(Keyword.has_key?(request.resource_ids, &1)))
    end

    test "override existing id with same name" do
      request =
        %Request{resource_ids: [customerId: "f51e3418-ff16-44d4-a081-a932d882dd18"]}
        |> Request.id(:customerId, "3eff5ae1-547b-464a-bac8-da971c7a0a05")

      assert Keyword.fetch!(request.resource_ids, :customerId) == "3eff5ae1-547b-464a-bac8-da971c7a0a05"
    end
  end

  describe ".ids/2" do
    test "add ids to the existing ones" do
      request =
        %Request{resource_ids: [customerId: "f51e3418-ff16-44d4-a081-a932d882dd18"]}
        |> Request.ids(
          [
            financialInstitutionId: "3eff5ae1-547b-464a-bac8-da971c7a0a05",
            userId: "a7dc2ea7-7749-4233-9569-6863e979f6ca"
          ]
        )

      assert [:customerId, :financialInstitutionId, :userId]
          |> Enum.all?(&(Keyword.has_key?(request.resource_ids, &1)))
    end

    test "override existing ids with the same name" do
      request =
        %Request{resource_ids: [customerId: "f51e3418-ff16-44d4-a081-a932d882dd18"]}
        |> Request.ids(
          [
            financialInstitutionId: "3eff5ae1-547b-464a-bac8-da971c7a0a05",
            customerId: "a7dc2ea7-7749-4233-9569-6863e979f6ca"
          ]
        )

        assert Keyword.has_key?(request.resource_ids, :financialInstitutionId)
        assert Keyword.get(request.resource_ids, :customerId)
                  == "a7dc2ea7-7749-4233-9569-6863e979f6ca"
    end
  end
end
