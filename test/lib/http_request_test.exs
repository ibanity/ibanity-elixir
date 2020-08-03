defmodule Ibanity.HttpRequestTest do
  use ExUnit.Case
  alias Ibanity.{HttpRequest, Request}

  @api_schema_path ~w(xs2a customer accounts)

  describe ".build" do
    test "default pagination limit" do
      {:ok, res} =
        %Request{}
        |> HttpRequest.build(:get, @api_schema_path)

      assert res.uri == "https://api.ibanity.com/customer/accounts"
    end

    test "specifies pagination limit" do
      {:ok, res} =
        50
        |> Request.limit
        |> HttpRequest.build(:get, @api_schema_path)

      assert res.uri == "https://api.ibanity.com/customer/accounts?limit=50"
    end

    test "specifies pagination 'before' cursor" do
      {:ok, res} =
        Request.before_id("cef1f4de-5710-4a42-b233-7783cf5397a2")
        |> HttpRequest.build(:get, @api_schema_path)

      assert res.uri ==
               "https://api.ibanity.com/customer/accounts?before=cef1f4de-5710-4a42-b233-7783cf5397a2"
    end

    test "specifies pagination 'after' cursor" do
      {:ok, res} =
        Request.after_id("dad219f6-a389-4c91-bb86-bc509c1dd64c")
        |> HttpRequest.build(:get, @api_schema_path)

      assert res.uri ==
               "https://api.ibanity.com/customer/accounts?after=dad219f6-a389-4c91-bb86-bc509c1dd64c"
    end

    test "specify all pagination options" do
      {:ok, res} =
        50
        |>Request.limit
        |> Request.before_id("27e718a7-af87-479f-bf78-b05027080188")
        |> Request.after_id("a6299d4d-eb81-4dfb-bb1b-b727000b2621")
        |> HttpRequest.build(:get, @api_schema_path)

      assert res.uri ==
               "https://api.ibanity.com/customer/accounts?" <>
                 "limit=50" <>
                 "&" <>
                 "before=27e718a7-af87-479f-bf78-b05027080188" <>
                 "&" <> "after=a6299d4d-eb81-4dfb-bb1b-b727000b2621"
    end

    test "specifies country filter" do
      {:ok, res} =
        %Request{}
        |> Request.query_params(filter: %{ country: "BE" })
        |> HttpRequest.build(:get, @api_schema_path)

      assert res.uri == "https://api.ibanity.com/customer/accounts" <>
                          "?filter[country]=BE"
    end

    test "specifies name filter" do
      filter = %{
        name: %{
          contains: "Jack"
        }
      }
      {:ok, res} =
        %Request{}
        |> Request.query_params(filter: filter)
        |> HttpRequest.build(:get, @api_schema_path)

      assert res.uri == "https://api.ibanity.com/customer/accounts" <>
                          "?filter[name][contains]=Jack"
    end
  end
end
