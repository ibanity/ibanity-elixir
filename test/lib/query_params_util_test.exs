defmodule Ibanity.QueryParamsUtilTest do
  use ExUnit.Case
  alias Ibanity.QueryParamsUtil

  describe "encode_query/1" do
    test "no query params" do
      res = QueryParamsUtil.encode_query([])

      assert res == ""
    end

    test "simple params" do
      res = QueryParamsUtil.encode_query([limit: 10])

      assert res == "limit=10"
    end

    test "multiple params" do
      res = QueryParamsUtil.encode_query([limit: 10, before: "cursor"])

      assert res == "limit=10&before=cursor"
    end

    test "nested params" do
      query_params = [
        filter: %{
          name: %{
            eq: "Einstein"
          },
          country: %{
            eq: "DE"
          }
        }
      ]
      res = QueryParamsUtil.encode_query(query_params)

      assert res == "filter[country][eq]=DE&filter[name][eq]=Einstein"
    end
  end
end
