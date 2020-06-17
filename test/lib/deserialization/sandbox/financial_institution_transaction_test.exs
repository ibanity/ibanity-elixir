defmodule Ibanity.Sandbox.FinancialInstitutionTransaction.DeserializationTest do
  use ExUnit.Case
  import Ibanity.JsonDeserializer
  alias Ibanity.DateTimeUtil

  test "deserialize a financial institution transaction" do
    data = %{
      "type" => "financialInstitutionTransaction",
      "relationships" => %{
        "financialInstitutionAccount" => %{
          "links" => %{
            "related" =>
              "https://api.ibanity.com/sandbox/financial-institutions/ad6fa583-2616-4a11-8b8d-eb98c53e2905/financial-institution-users/..."
          },
          "data" => %{
            "type" => "financialInstitutionAccount",
            "id" => "d9d60751-b741-4fa6-8524-8f9a066ca037"
          }
        }
      },
      "links" => %{
        "self" =>
          "https://api.ibanity.com/sandbox/financial-institutions/ad6fa583-2616-4a11-8b8d-eb98c53e2905/..."
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
        "amount" => 84.42,
        "internalReference" => "ref_123",
        "bankTransactionCode" => "PMNT-IRCT-ESCT",
        "proprietaryBankTransactionCode" => "prop123",
        "endToEndId" => "61dd468606594217af9965ad3928280d",
        "purposeCode" => "CASH",
        "mandateId" => "12345678",
        "creditorId" => "98765",
        "digest" => "d59f256988324499809c18a8d4a8be60ff36e3d1e0c89c380be49e032e39a287",
        "additionalInformation" => "addional"
      }
    }

    actual = deserialize(data)

    expected = %Ibanity.Sandbox.FinancialInstitutionTransaction{
      id: "0b0ffc56-db20-4dc5-b9f3-189e4317812e",
      value_date: DateTimeUtil.parse("2017-05-22T00:00:00Z"),
      updated_at: DateTimeUtil.parse("2018-10-18T15:13:12.365329Z"),
      remittance_information_type: "unstructured",
      remittance_information: "NEW SHOES",
      execution_date: DateTimeUtil.parse("2017-05-25T00:00:00Z"),
      description: "Small Cotton Shoes",
      currency: "EUR",
      created_at: DateTimeUtil.parse("2018-10-18T15:13:12.365318Z"),
      counterpart_reference: "BE9786154282554",
      counterpart_name: "Otro Bank",
      amount: 84.42,
      internal_reference: "ref_123",
      bank_transaction_code: "PMNT-IRCT-ESCT",
      proprietary_bank_transaction_code: "prop123",
      end_to_end_id: "61dd468606594217af9965ad3928280d",
      purpose_code: "CASH",
      mandate_id: "12345678",
      creditor_id:  "98765",
      digest: "d59f256988324499809c18a8d4a8be60ff36e3d1e0c89c380be49e032e39a287",
      additional_information: "addional",
      financial_institution_account_id: "d9d60751-b741-4fa6-8524-8f9a066ca037"
    }

    assert expected == actual
  end
end
