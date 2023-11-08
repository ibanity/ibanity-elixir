defmodule Ibanity.Xs2a.Transaction.DeserializationTest do
  use ExUnit.Case
  import Ibanity.JsonDeserializer
  alias Ibanity.DateTimeUtil

  test "deserializes a transaction" do
    data = %{
      "type" => "transaction",
      "relationships" => %{
        "account" => %{
          "links" => %{
            "related" =>
              "https://api.ibanity.com/xs2a/customer/financial-institutions/0f88f06c-3cfe-4b8f-9338-69981c0c4632/accounts/ce3893cd-fff5-435a-bdfc-d55a7e98df6f"
          },
          "data" => %{
            "type" => "account",
            "id" => "ce3893cd-fff5-435a-bdfc-d55a7e98df6f"
          }
        }
      },
      "links" => %{
        "self" =>
          "https://api.ibanity.com/xs2a/customer/financial-institutions/0f88f06c-3cfe-4b8f-9338-69981c0c4632/accounts/ce3893cd-fff5-435a-bdfc-d55a7e98df6f/transactions/c847e0f0-9178-47d7-9c11-1f41f9fca6ff"
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
        "amount" => 6.99,
        "internalReference" => "ref_123",
        "bankTransactionCode" => "PMNT-IRCT-ESCT",
        "proprietaryBankTransactionCode" => "prop123",
        "endToEndId" => "61dd468606594217af9965ad3928280d",
        "purposeCode" => "CASH",
        "mandateId" => "12345678",
        "creditorId" => "98765",
        "digest" => "d59f256988324499809c18a8d4a8be60ff36e3d1e0c89c380be49e032e39a287",
        "additionalInformation" => "addional",
        "fee" => 3.14,
        "cardReference" => "1234",
        "cardReferenceType" => "MASKEDPAN"
      }
    }

    actual = deserialize(data)

    expected = %Ibanity.Xs2a.Transaction{
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
      internal_reference: "ref_123",
      bank_transaction_code: "PMNT-IRCT-ESCT",
      proprietary_bank_transaction_code: "prop123",
      end_to_end_id: "61dd468606594217af9965ad3928280d",
      purpose_code: "CASH",
      mandate_id: "12345678",
      creditor_id:  "98765",
      digest: "d59f256988324499809c18a8d4a8be60ff36e3d1e0c89c380be49e032e39a287",
      additional_information: "addional",
      fee: 3.14,
      card_reference: "1234",
      card_reference_type: "MASKEDPAN",
      account_id: "ce3893cd-fff5-435a-bdfc-d55a7e98df6f",
      self:
        "https://api.ibanity.com/xs2a/customer/financial-institutions/0f88f06c-3cfe-4b8f-9338-69981c0c4632/accounts/ce3893cd-fff5-435a-bdfc-d55a7e98df6f/transactions/c847e0f0-9178-47d7-9c11-1f41f9fca6ff"
    }

    assert actual == expected
  end
end
