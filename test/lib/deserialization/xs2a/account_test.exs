defmodule Ibanity.Xs2a.Account.DeserializationTest do
  use ExUnit.Case
  import Ibanity.JsonDeserializer
  alias Ibanity.Xs2a.Account
  alias Ibanity.DateTimeUtil

  test "deserialize an account" do
    data = %{
      "type" => "account",
      "relationships" => %{
        "transactions" => %{
          "links" => %{
            "related" =>
              "https://api.ibanity.com/customer/financial-institutions/0a089c79-bfef-45e7-b647-a4654e4bff9f/accounts/2e016890-70a5-4892-8711-f34ef74c0b02/transactions",
            "meta" => %{
              "type" => "transaction"
            }
          }
        },
        "financialInstitution" => %{
          "links" => %{
            "related" =>
              "https://api.ibanity.com/financial-institutions/0a089c79-bfef-45e7-b647-a4654e4bff9f"
          },
          "data" => %{
            "type" => "financialInstitution",
            "id" => "0a089c79-bfef-45e7-b647-a4654e4bff9f"
          }
        }
      },
      "meta" => %{
        "synchronizedAt" => "2018-10-18T15:12:23.075Z",
        "latestSynchronization" => %{
          "type" => "synchronization",
          "id" => "fc1b358f-6220-4b84-9d38-fef3eb50b95f",
          "attributes" => %{
            "updatedAt" => "2018-10-18T15:12:23.075Z",
            "subtype" => "accountDetails",
            "status" => "success",
            "resourceType" => "account",
            "resourceId" => "2e016890-70a5-4892-8711-f34ef74c0b02",
            "errors" => [],
            "createdAt" => "2018-10-18T15:12:22.699782Z"
          }
        }
      },
      "links" => %{
        "self" =>
          "https://api.ibanity.com/customer/financial-institutions/0a089c79-bfef-45e7-b647-a4654e4bff9f/accounts/2e016890-70a5-4892-8711-f34ef74c0b02"
      },
      "id" => "2e016890-70a5-4892-8711-f34ef74c0b02",
      "attributes" => %{
        "subtype" => "checking",
        "referenceType" => "IBAN",
        "reference" => "BE0656228978098466",
        "description" => "Checking account",
        "currentBalance" => 0,
        "currency" => "EUR",
        "availableBalance" => 0,
        "internal_reference" => "ref_123",
        "product" => "Easy account",
        "holder_name" => "John Doe",
        "current_balance_changed_at" => "2018-10-18T15:12:23.073Z",
        "current_balance_variation_observed_at" => "2018-10-18T15:12:23.074Z",
        "current_balance_reference_date" => "2018-10-18T15:12:23.075Z",
        "available_balance_changed_at" => "2018-10-18T15:12:23.076Z",
        "available_balance_variation_observed_at" => "2018-10-18T15:12:23.077Z",
        "available_balance_reference_date" => "2018-10-18T15:12:23.078Z",
        "authorized_at" => "2018-10-18T15:12:23.079Z",
        "authorization_expiration_expected_at" => "2018-10-18T15:12:23.080Z"
      }
    }

    actual = data |> deserialize

    expected = %Account{
      id: "2e016890-70a5-4892-8711-f34ef74c0b02",
      subtype: "checking",
      reference_type: "IBAN",
      reference: "BE0656228978098466",
      description: "Checking account",
      current_balance: 0,
      currency: "EUR",
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
      financial_institution:
        "https://api.ibanity.com/financial-institutions/0a089c79-bfef-45e7-b647-a4654e4bff9f",
      financial_institution_id: "0a089c79-bfef-45e7-b647-a4654e4bff9f",
      transactions:
        "https://api.ibanity.com/customer/financial-institutions/0a089c79-bfef-45e7-b647-a4654e4bff9f/accounts/2e016890-70a5-4892-8711-f34ef74c0b02/transactions",
      synchronized_at: DateTimeUtil.parse("2018-10-18T15:12:23.075Z"),
      latest_synchronization: %{
        "type" => "synchronization",
        "id" => "fc1b358f-6220-4b84-9d38-fef3eb50b95f",
        "attributes" => %{
          "updatedAt" => "2018-10-18T15:12:23.075Z",
          "subtype" => "accountDetails",
          "status" => "success",
          "resourceType" => "account",
          "resourceId" => "2e016890-70a5-4892-8711-f34ef74c0b02",
          "errors" => [],
          "createdAt" => "2018-10-18T15:12:22.699782Z"
        }
      }
    }

    assert actual == expected
  end
end
