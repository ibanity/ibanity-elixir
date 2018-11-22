defmodule Ibanity.FinancialInstitutionTransaction.DeserializationTest do
  use ExUnit.Case
  import Ibanity.JsonDeserializer

  test "deserialize a financial institution transaction" do
    data = %{
      "type" => "financialInstitutionTransaction",
      "relationships" => %{
        "financialInstitutionAccount" => %{
          "links" => %{
            "related" => "https://api.ibanity.com/sandbox/financial-institutions/ad6fa583-2616-4a11-8b8d-eb98c53e2905/financial-institution-users/..."
          },
          "data" => %{
            "type" => "financialInstitutionAccount",
            "id" => "d9d60751-b741-4fa6-8524-8f9a066ca037"
          }
        }
      },
      "links" => %{
        "self" => "https://api.ibanity.com/sandbox/financial-institutions/ad6fa583-2616-4a11-8b8d-eb98c53e2905/..."
      },
      "id" => "0b0ffc56-db20-4dc5-b9f3-189e4317812e",
      "attributes" => %{
        "valueDate" => "2017-05-22T00:00:00Z",
        "updatedAt" => "2018-10-18T15:13:12.365329Z",
        "remittanceInformationType" => "unstructured",
        "remittanceInformation" => "NEW SHOES",
        "executionDate" => "2017-05-25T00:00:00Z",
        "description" => "Small Cotton Shoes",
        "currency" => "EUR",
        "createdAt" => "2018-10-18T15:13:12.365318Z",
        "counterpartReference" => "BE9786154282554",
        "counterpartName" => "Otro Bank",
        "amount" => 84.42
      }
    }

    actual = deserialize(data)
    expected = %Ibanity.FinancialInstitutionTransaction{
      id: "0b0ffc56-db20-4dc5-b9f3-189e4317812e",
      value_date: "2017-05-22T00:00:00Z",
      updated_at: "2018-10-18T15:13:12.365329Z",
      remittance_information_type: "unstructured",
      remittance_information: "NEW SHOES",
      execution_date: "2017-05-25T00:00:00Z",
      description: "Small Cotton Shoes",
      currency: "EUR",
      created_at: "2018-10-18T15:13:12.365318Z",
      counterpart_reference: "BE9786154282554",
      counterpart_name: "Otro Bank",
      amount: 84.42
    }

    assert expected == actual
  end
end