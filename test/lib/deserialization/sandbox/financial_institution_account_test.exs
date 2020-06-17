defmodule Ibanity.Sandbox.FinancialInstitutionAccount.DeserializerTest do
  use ExUnit.Case
  import Ibanity.JsonDeserializer
  alias Ibanity.DateTimeUtil
  alias Ibanity.Sandbox.FinancialInstitutionAccount

  test "deserialize a financial institution account" do
    data = %{
      "type" => "financialInstitutionAccount",
      "relationships" => %{
        "financialInstitutionUser" => %{
          "links" => %{
            "related" =>
              "https://api.ibanity.com/sandbox/financial-institution-users/a64f42ec-c801-41a7-8801-0f815ca42e9e"
          },
          "data" => %{
            "type" => "financialInstitutionUser",
            "id" => "a64f42ec-c801-41a7-8801-0f815ca42e9e"
          }
        },
        "financialInstitutionTransactions" => %{
          "links" => %{
            "related" =>
              "https://api.ibanity.com/sandbox/financial-institutions/b5d6c5f9-e1d2-4cd1-a2aa-7baf964f7bf7/.../financial-institution-transactions",
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
        "self" =>
          "https://api.ibanity.com/sandbox/financial-institutions/.../financial-institution-accounts/b1c1e046-309b-49b8-bc5d-c4b1f82f61a7"
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
        "availableBalance" => 0,
        "internalReference" => "ref_123",
        "product" => "Easy account",
        "holderName" => "John Doe",
        "currentBalanceChangedAt" => "2018-10-18T15:12:23.073Z",
        "currentBalanceVariationObservedAt" => "2018-10-18T15:12:23.074Z",
        "currentBalanceReferenceDate" => "2018-10-18T15:12:23.075Z",
        "availableBalanceChangedAt" => "2018-10-18T15:12:23.076Z",
        "availableBalanceVariationObservedAt" => "2018-10-18T15:12:23.077Z",
        "availableBalanceReferenceDate" => "2018-10-18T15:12:23.078Z",
        "authorizedAt" => "2018-10-18T15:12:23.079Z",
        "authorizationExpirationExpectedAt" => "2018-10-18T15:12:23.080Z"
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
      internal_reference: "ref_123",
      product: "Easy account",
      holder_name: "John Doe",
      current_balance_changed_at: DateTimeUtil.parse("2018-10-18T15:12:23.073Z"),
      current_balance_variation_observed_at: DateTimeUtil.parse("2018-10-18T15:12:23.074Z"),
      current_balance_reference_date: DateTimeUtil.parse("2018-10-18T15:12:23.075Z"),
      available_balance_changed_at: DateTimeUtil.parse("2018-10-18T15:12:23.076Z"),
      available_balance_variation_observed_at: DateTimeUtil.parse("2018-10-18T15:12:23.077Z"),
      available_balance_reference_date: DateTimeUtil.parse("2018-10-18T15:12:23.078Z"),
      authorized_at: DateTimeUtil.parse("2018-10-18T15:12:23.079Z"),
      authorization_expiration_expected_at: DateTimeUtil.parse("2018-10-18T15:12:23.080Z"),
      financial_institution_user:
        "https://api.ibanity.com/sandbox/financial-institution-users/a64f42ec-c801-41a7-8801-0f815ca42e9e",
      financial_institution_user_id: "a64f42ec-c801-41a7-8801-0f815ca42e9e",
      financial_institution_id: "b5d6c5f9-e1d2-4cd1-a2aa-7baf964f7bf7",
      transactions:
        "https://api.ibanity.com/sandbox/financial-institutions/b5d6c5f9-e1d2-4cd1-a2aa-7baf964f7bf7/.../financial-institution-transactions"
    }

    assert actual == expected
  end
end
