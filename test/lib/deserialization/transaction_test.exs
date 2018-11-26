defmodule Ibanity.Transaction.DeserializationTest do
  use ExUnit.Case
  import Ibanity.JsonDeserializer
  alias Ibanity.DateTimeUtil

  test "deserializes a transaction" do
    data = %{
      "type" => "transaction",
      "relationships" => %{
        "account" => %{
          "links" => %{
            "related" => "https://api.ibanity.com/customer/financial-institutions/0f88f06c-3cfe-4b8f-9338-69981c0c4632/accounts/ce3893cd-fff5-435a-bdfc-d55a7e98df6f"
          },
          "data" => %{
            "type" => "account",
            "id" => "ce3893cd-fff5-435a-bdfc-d55a7e98df6f"
          }
        }
      },
      "links" => %{
        "self" => "https://api.ibanity.com/customer/financial-institutions/0f88f06c-3cfe-4b8f-9338-69981c0c4632/accounts/ce3893cd-fff5-435a-bdfc-d55a7e98df6f/transactions/c847e0f0-9178-47d7-9c11-1f41f9fca6ff"
      },
      "id" => "c847e0f0-9178-47d7-9c11-1f41f9fca6ff",
      "attributes" => %{
        "valueDate" => "2017-05-22T00:00:00Z",
        "remittanceInformationType" => "unstructured",
        "remittanceInformation" => "NEW SHOES",
        "executionDate" => "2017-05-25T00:00:00Z",
        "description" => "Small Cotton Shoes",
        "currency" => "EUR",
        "counterpartReference" => "BE1832277133817274",
        "counterpartName" => "ABU DHABI ISLAMIC BANK",
        "amount" => 6.99
      }
    }

    actual = deserialize(data)
    expected = %Ibanity.Transaction{
      id: "c847e0f0-9178-47d7-9c11-1f41f9fca6ff",
      value_date: DateTimeUtil.parse("2017-05-22T00:00:00Z"),
      remittance_information_type: "unstructured",
      remittance_information: "NEW SHOES",
      execution_date: DateTimeUtil.parse("2017-05-25T00:00:00Z"),
      description: "Small Cotton Shoes",
      currency: "EUR",
      counterpart_reference: "BE1832277133817274",
      counterpart_name: "ABU DHABI ISLAMIC BANK",
      amount: 6.99,
      self: "https://api.ibanity.com/customer/financial-institutions/0f88f06c-3cfe-4b8f-9338-69981c0c4632/accounts/ce3893cd-fff5-435a-bdfc-d55a7e98df6f/transactions/c847e0f0-9178-47d7-9c11-1f41f9fca6ff"
    }

    assert actual == expected
  end
end
