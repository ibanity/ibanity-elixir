defmodule Ibanity.Xs2a.Synchronization.DeserializationTest do
  use ExUnit.Case
  import Ibanity.JsonDeserializer
  alias Ibanity.DateTimeUtil
  alias Ibanity.Xs2a.Synchronization

  test "deserializes a synchronization" do
    data = %{
      "type" => "synchronization",
      "id" => "e8b19b5e-068b-4802-a2da-0c641145479c",
      "attributes" => %{
        "updatedAt" => "2018-10-18T15:11:42.341Z",
        "subtype" => "accountDetails",
        "status" => "success",
        "resourceType" => "account",
        "resourceId" => "a23b8b7e-b118-43da-80d6-cf0b4c6b1707",
        "customerOnline" => true,
        "customerIpAddress" => "123.123.123.123",
        "errors" => [],
        "createdAt" => "2018-10-18T15:11:41.489069Z"
      }
    }

    actual = deserialize(data)

    expected = %Synchronization{
      id: "e8b19b5e-068b-4802-a2da-0c641145479c",
      updated_at: DateTimeUtil.parse("2018-10-18T15:11:42.341Z"),
      subtype: "accountDetails",
      status: "success",
      resource_type: "account",
      resource_id: "a23b8b7e-b118-43da-80d6-cf0b4c6b1707",
      customer_online: true,
      customer_ip_address: "123.123.123.123",
      errors: [],
      created_at: DateTimeUtil.parse("2018-10-18T15:11:41.489069Z")
    }

    assert expected == actual
  end
end
