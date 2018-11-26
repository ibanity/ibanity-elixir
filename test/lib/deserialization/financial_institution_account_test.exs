defmodule Ibanity.FinancialInstitutionAccount.DeserializerTest do
  use ExUnit.Case
  import Ibanity.JsonDeserializer
  alias Ibanity.{DateTimeUtil, FinancialInstitutionAccount}

  test "deserialize a financial institution account" do
    data = %{
      "type" => "financialInstitutionAccount",
      "relationships" => %{
        "financialInstitutionUser" => %{
          "links" => %{
            "related" => "https://api.ibanity.com/sandbox/financial-institution-users/a64f42ec-c801-41a7-8801-0f815ca42e9e"
          },
          "data" => %{
            "type" => "financialInstitutionUser",
            "id" => "a64f42ec-c801-41a7-8801-0f815ca42e9e"
          }
        },
        "financialInstitutionTransactions" => %{
          "links" => %{
            "related" => "https://api.ibanity.com/sandbox/financial-institutions/b5d6c5f9-e1d2-4cd1-a2aa-7baf964f7bf7/.../financial-institution-transactions",
            "meta" => %{
              "type" => "financialInstitutionTransaction"
            }
          }
        },
        "financialInstitution" => %{
          "data" => %{
            "type" => "financialInstitution",
            "id" => "b5d6c5f9-e1d2-4cd1-a2aa-7baf964f7bf7"
          }
        }
      },
      "links" => %{
        "self" => "https://api.ibanity.com/sandbox/financial-institutions/.../financial-institution-accounts/b1c1e046-309b-49b8-bc5d-c4b1f82f61a7"
      },
      "id" => "b1c1e046-309b-49b8-bc5d-c4b1f82f61a7",
      "attributes" => %{
        "updatedAt" => "2018-10-18T15:12:57.950294Z",
        "subtype" => "checking",
        "referenceType" => "IBAN",
        "reference" => "BE6540413182550839",
        "description" => "Checking account",
        "currentBalance" => 0,
        "currency" => "EUR",
        "createdAt" => "2018-10-18T15:12:57.950279Z",
        "availableBalance" => 0
      }
    }
    actual = deserialize(data)

    expected = %FinancialInstitutionAccount{
      id: "b1c1e046-309b-49b8-bc5d-c4b1f82f61a7",
      updated_at: DateTimeUtil.parse("2018-10-18T15:12:57.950294Z"),
      subtype: "checking",
      reference_type: "IBAN",
      reference: "BE6540413182550839",
      description: "Checking account",
      current_balance: 0,
      currency: "EUR",
      created_at: DateTimeUtil.parse("2018-10-18T15:12:57.950279Z"),
      available_balance: 0,
      financial_institution_user: "https://api.ibanity.com/sandbox/financial-institution-users/a64f42ec-c801-41a7-8801-0f815ca42e9e",
      transactions: "https://api.ibanity.com/sandbox/financial-institutions/b5d6c5f9-e1d2-4cd1-a2aa-7baf964f7bf7/.../financial-institution-transactions"
    }

    assert actual == expected
  end
end