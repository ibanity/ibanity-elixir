defmodule Ibanity.HttpRequestTest do
  use ExUnit.Case
  alias Ibanity.{HttpRequest, Request}

  @api_schema_path ~w(customer accounts)

  describe ".build" do
    test "default pagination limit" do
      {:ok, res} =
        %Request{}
        |> HttpRequest.build(:get, @api_schema_path)

      assert res.query_params == [limit: 10]
    end

    test "specifies pagination limit" do
      {:ok, res} =
        Request.limit(50)
        |> HttpRequest.build(:get, @api_schema_path)

      assert res.query_params == [limit: 50]
    end

    test "specifies pagination 'before' cursor" do
      {:ok, res} =
        Request.before_id("cef1f4de-5710-4a42-b233-7783cf5397a2")
        |> HttpRequest.build(:get, @api_schema_path)

      assert res.query_params == [before: "cef1f4de-5710-4a42-b233-7783cf5397a2", limit: 10]
    end

    test "specifies pagination 'after' cursor" do
      {:ok, res} =
        Request.after_id("dad219f6-a389-4c91-bb86-bc509c1dd64c")
        |> HttpRequest.build(:get, @api_schema_path)

      assert res.query_params == [after: "dad219f6-a389-4c91-bb86-bc509c1dd64c", limit: 10]
    end

    test "specify all pagination options" do
      {:ok, res} =
        Request.limit(50)
        |> Request.before_id("27e718a7-af87-479f-bf78-b05027080188")
        |> Request.after_id("a6299d4d-eb81-4dfb-bb1b-b727000b2621")
        |> HttpRequest.build(:get, @api_schema_path)

      assert res.query_params == [
        after:  "a6299d4d-eb81-4dfb-bb1b-b727000b2621",
        before: "27e718a7-af87-479f-bf78-b05027080188",
        limit:  50
      ]
    end
  end
end
