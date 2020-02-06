defmodule Ibanity.JsonDeserializer do
  @moduledoc false
  alias Ibanity.DateTimeUtil

  @type_mappings %{
    "accountInformationAccessRequest" => Ibanity.Xs2a.AccountInformationAccessRequest,
    "account" => Ibanity.Xs2a.Account,
    "customerAccessToken" => Ibanity.Xs2a.CustomerAccessToken,
    "customer" => Ibanity.Xs2a.Customer,
    "financialInstitutionTransaction" => Ibanity.Sandbox.FinancialInstitutionTransaction,
    "financialInstitutionHolding" => Ibanity.Sandbox.FinancialInstitutionHolding,
    "financialInstitutionAccount" => Ibanity.Sandbox.FinancialInstitutionAccount,
    "financialInstitutionUser" => Ibanity.Sandbox.FinancialInstitutionUser,
    "financialInstitution" => Ibanity.Xs2a.FinancialInstitution,
    "paymentInitiationRequest" => Ibanity.Xs2a.PaymentInitiationRequest,
    "transaction" => Ibanity.Xs2a.Transaction,
    "holding" => Ibanity.Xs2a.Holding,
    "synchronization" => Ibanity.Xs2a.Synchronization,
    "consent" => Ibanity.Consent.Consent,
    "processingOperation" => Ibanity.Consent.ProcessingOperation,
    "xs2aBillingReport" => Ibanity.Billing.Xs2a.Report,
    "nbbReport" => Ibanity.Reporting.Xs2a.NbbReport,
    "nbbReportAiSynchronization" => Ibanity.Reporting.Xs2a.NbbReportAiSynchronization,
    "accountInformationAccessRequestAuthorization" => Ibanity.Xs2a.AccountInformationAccessRequestAuthorization,
    "paymentInitiationRequestAuthorization" => Ibanity.Xs2a.PaymentInitiationRequestAuthorization
  }

  def deserialize(item) do
    deserialize(item, nil)
  end
  def deserialize(item, nil) do
    deserialize(item, Map.fetch!(item, "type"))
  end
  def deserialize(item, resource_type) do
    return_type = Map.fetch!(@type_mappings, resource_type)
    mapping = return_type.key_mapping()

    keys =
      Enum.map(mapping, fn {key, {path, type}} ->
        {key, item |> get_in(path) |> deserialize_field(type)}
      end)

    struct(return_type, keys)
  end

  defp deserialize_field(nil, _), do: nil
  defp deserialize_field(field, :datetime) do
    DateTimeUtil.parse(field)
  end
  defp deserialize_field(field, _) do
    field
  end
end
