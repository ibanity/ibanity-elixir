defmodule Ibanity.Xs2a.FinancialInstitution.DeserializationTest do
  use ExUnit.Case
  import Ibanity.JsonDeserializer

  test "deserializes a financial institution" do
    data = %{
      "type" => "financialInstitution",
      "links" => %{
        "self" =>
          "https://api.ibanity.com/financial-institutions/01faf09c-038d-43f3-8e0c-d0aaf3e0e176"
      },
      "id" => "01faf09c-038d-43f3-8e0c-d0aaf3e0e176",
      "attributes" => %{
        "sandbox" => true,
        "name" => "ABN AMRO HOARE GOVETT CORPORATE FINANCE LTD. 7",
        "maxRequestedAccountReferences" => 3,
        "minRequestedAccountReferences" => 1,
        "requiresCredentialStorage" => false,
        "paymentsProductTypes" => ["sepaCreditTransfer"],
        "authorizationModels" => ["detailed", "financialInstitutionOffered"]
      }
    }

    actual = deserialize(data)

    expected = %Ibanity.Xs2a.FinancialInstitution{
      id: "01faf09c-038d-43f3-8e0c-d0aaf3e0e176",
      sandbox: true,
      name: "ABN AMRO HOARE GOVETT CORPORATE FINANCE LTD. 7",
      max_requested_account_references: 3,
      min_requested_account_references: 1,
      requires_credential_storage: false,
      payments_product_types: ["sepaCreditTransfer"],
      authorization_models: ["detailed", "financialInstitutionOffered"],
      self_link:
        "https://api.ibanity.com/financial-institutions/01faf09c-038d-43f3-8e0c-d0aaf3e0e176"
    }

    assert expected == actual
  end
end
