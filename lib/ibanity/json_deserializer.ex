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
    "financialInstitutionCountry" => Ibanity.Xs2a.FinancialInstitutionCountry,
    "financialInstitution" => Ibanity.Xs2a.FinancialInstitution,
    "paymentInitiationRequest" => Ibanity.Xs2a.PaymentInitiationRequest,
    "periodicPaymentInitiationRequest" => Ibanity.Xs2a.PeriodicPaymentInitiationRequest,
    "bulkPaymentInitiationRequest" => Ibanity.Xs2a.BulkPaymentInitiationRequest,
    "paymentItem" => Ibanity.Xs2a.BulkPaymentInitiationRequest.Payment,
    "transaction" => Ibanity.Xs2a.Transaction,
    "holding" => Ibanity.Xs2a.Holding,
    "synchronization" => Ibanity.Xs2a.Synchronization,
    "consent" => Ibanity.Consent.Consent,
    "processingOperation" => Ibanity.Consent.ProcessingOperation,
    "xs2aBillingReport" => Ibanity.Billing.Xs2a.Report,
    "financialInstitutionStatus" => Ibanity.Billing.Xs2a.FinancialInstitutionStatus,
    "nbbReport" => Ibanity.Reporting.Xs2a.NbbReport,
    "nbbReportAiSynchronization" => Ibanity.Reporting.Xs2a.NbbReportAiSynchronization,
    "accountInformationAccessRequestAuthorization" => Ibanity.Xs2a.AccountInformationAccessRequestAuthorization,
    "paymentInitiationRequestAuthorization" => Ibanity.Xs2a.PaymentInitiationRequestAuthorization,
    "key" => Ibanity.Webhooks.Key,
    "xs2a.synchronization.succeededWithoutChange" => Ibanity.Webhooks.Xs2a.Synchronization.SucceededWithoutChange,
    "xs2a.account.transactionsUpdated" => Ibanity.Webhooks.Xs2a.Account.TransactionsUpdated,
    "xs2a.account.transactionsCreated" => Ibanity.Webhooks.Xs2a.Account.TransactionsCreated,
    "xs2a.synchronization.failed" => Ibanity.Webhooks.Xs2a.Synchronization.Failed,
    "xs2a.account.detailsUpdated" => Ibanity.Webhooks.Xs2a.Account.DetailsUpdated
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

  defp deserialize_field(field, :string) when is_list(field), do: field

  defp deserialize_field(field, type) when is_list(field) do
    Enum.map(field, &(deserialize(&1, type)))
  end

  defp deserialize_field(field, :datetime), do: DateTimeUtil.parse(field)

  defp deserialize_field(field, :date), do: Date.from_iso8601!(field)

  defp deserialize_field(field, _), do: field
end
