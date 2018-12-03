defmodule Ibanity.AccountInformationAccessRequest.DeserializationTest do
  use ExUnit.Case
  import Ibanity.JsonDeserializer
  alias Ibanity.AccountInformationAccessRequest

  test "deserialize an account information access request" do
    data = %{
      "type" => "accountInformationAccessRequest",
      "links" => %{
        "redirect" =>
          "https://callback.ibanity.com/sandbox/fi/aiar/i?state=dmF1bHQ6djE6RlBlQ2RKQ05TU..."
      },
      "id" => "18f5fc93-0659-4734-b1e4-e274537db6ff",
      "attributes" => %{
        "requestedAccountReferences" => [
          "BE6338957016536095"
        ]
      }
    }

    actual = deserialize(data)

    expected = %AccountInformationAccessRequest{
      id: "18f5fc93-0659-4734-b1e4-e274537db6ff",
      redirect_link:
        "https://callback.ibanity.com/sandbox/fi/aiar/i?state=dmF1bHQ6djE6RlBlQ2RKQ05TU...",
      requested_account_references: ["BE6338957016536095"]
    }

    assert actual == expected
  end
end
