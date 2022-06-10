defmodule Ibanity.Xs2a.BulkPaymentInitiationRequest.DeserializationTest do
  use ExUnit.Case
  import Ibanity.JsonDeserializer
  alias Ibanity.Xs2a.BulkPaymentInitiationRequest

  test "deserializes a payment initiation request" do
    data = %{
      "type" => "bulkPaymentInitiationRequest",
      "relationships" => %{
        "financialInstitution" => %{
          "links" => %{
            "related" =>
              "https://api.ibanity.com/financial-institutions/b2c76f6b-ab34-4843-8ef3-84300ef98a09"
          },
          "data" => %{
            "type" => "financialInstitution",
            "id" => "b2c76f6b-ab34-4843-8ef3-84300ef98a09"
          }
        }
      },
      "links" => %{
        "redirect" => "https://callback.ibanity.com/sandbox/fi/pir/i?state=dmF1bHQ6djE6V1FLZFp..."
      },
      "id" => "6c1b78d1-a574-4b84-847f-bb7aa0fe43ef",
      "attributes" => %{
        "status" => "received",
        "productType" => "sepa-credit-transfer",
        "endToEndId" => "301040f162f4459283bab984f8a113b2",
        "debtorName" => "Cassidy Hahn",
        "debtorAccountReferenceType" => "IBAN",
        "debtorAccountReference" => "BE5745665582716888",
        "consentReference" => "b57cca6b-74d6-4ac8-ba5d-4e28160d8dde",
        "skipIbanityCompletionCallback" => true,
        "allowFinancialInstitutionRedirectUri" => true,
        "batchBookingPreferred" => true,
        "payments" => [
          %{
            "remittanceInformationType" => "unstructured",
            "remittanceInformation" => "payment",
            "currency" => "EUR",
            "creditorName" => "Alex Creditor",
            "creditorAgentType" => "BIC",
            "creditorAgent" => "NBBEBEBB203",
            "creditorAccountReferenceType" => "IBAN",
            "creditorAccountReference" => "BE4359048312132562",
            "requestedExecutionDate" => "2020-06-12",
            "amount" => 59
          }
        ]
      }
    }

    actual = deserialize(data)

    expected = %BulkPaymentInitiationRequest{
      id: "6c1b78d1-a574-4b84-847f-bb7aa0fe43ef",
      consent_reference: "b57cca6b-74d6-4ac8-ba5d-4e28160d8dde",
      status: "received",
      product_type: "sepa-credit-transfer",
      end_to_end_id: "301040f162f4459283bab984f8a113b2",
      debtor_name: "Cassidy Hahn",
      debtor_account_reference_type: "IBAN",
      debtor_account_reference: "BE5745665582716888",
      skip_ibanity_completion_callback: true,
      allow_financial_institution_redirect_uri: true,
      batch_booking_preferred: true,
      payments: [
        %BulkPaymentInitiationRequest.Payment{
          currency: "EUR",
          creditor_name: "Alex Creditor",
          creditor_agent_type: "BIC",
          creditor_agent: "NBBEBEBB203",
          creditor_account_reference_type: "IBAN",
          creditor_account_reference: "BE4359048312132562",
          remittance_information_type: "unstructured",
          remittance_information: "payment",
          requested_execution_date: ~D[2020-06-12],
          amount: 59
        }
      ],
      redirect_link: "https://callback.ibanity.com/sandbox/fi/pir/i?state=dmF1bHQ6djE6V1FLZFp...",
      financial_institution_id: "b2c76f6b-ab34-4843-8ef3-84300ef98a09"
    }

    assert actual == expected
  end
end
