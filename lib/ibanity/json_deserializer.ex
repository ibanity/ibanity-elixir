defmodule Ibanity.JsonDeserializer do
  @moduledoc false
  alias Ibanity.DateTimeUtil

  @type_mappings %{
    "accountInformationAccessRequest" => Ibanity.Xs2a.AccountInformationAccessRequest,
    "account" => Ibanity.Xs2a.Account,
    "batchSynchronization" => Ibanity.Xs2a.BatchSynchronization,
    "customerAccessToken" => Ibanity.Xs2a.CustomerAccessToken,
    "customer" => Ibanity.Xs2a.Customer,
    "financialInstitutionTransaction" => Ibanity.Xs2a.Sandbox.FinancialInstitutionTransaction,
    "financialInstitutionHolding" => Ibanity.Xs2a.Sandbox.FinancialInstitutionHolding,
    "financialInstitutionAccount" => Ibanity.Xs2a.Sandbox.FinancialInstitutionAccount,
    "financialInstitutionUser" => Ibanity.Xs2a.Sandbox.FinancialInstitutionUser,
    "financialInstitutionCountry" => Ibanity.Xs2a.FinancialInstitutionCountry,
    "financialInstitution" => Ibanity.Xs2a.FinancialInstitution,
    "paymentInitiationRequest" => Ibanity.Xs2a.PaymentInitiationRequest,
    "paymentInitiationRequestAuthorization" => Ibanity.Xs2a.PaymentInitiationRequestAuthorization,
    "periodicPaymentInitiationRequest" => Ibanity.Xs2a.PeriodicPaymentInitiationRequest,
    "periodicPaymentInitiationRequestAuthorization" =>
      Ibanity.Xs2a.PeriodicPaymentInitiationRequestAuthorization,
    "bulkPaymentInitiationRequest" => Ibanity.Xs2a.BulkPaymentInitiationRequest,
    "bulkPaymentInitiationRequestAuthorization" =>
      Ibanity.Xs2a.BulkPaymentInitiationRequestAuthorization,
    "paymentItem" => Ibanity.Xs2a.BulkPaymentInitiationRequest.Payment,
    "pendingTransaction" => Ibanity.Xs2a.PendingTransaction,
    "transaction" => Ibanity.Xs2a.Transaction,
    "transactionDeleteRequest" => Ibanity.Xs2a.TransactionDeleteRequest,
    "holding" => Ibanity.Xs2a.Holding,
    "synchronization" => Ibanity.Xs2a.Synchronization,
    "consent" => Ibanity.Consent.Consent,
    "processingOperation" => Ibanity.Consent.ProcessingOperation,
    "xs2aBillingReport" => Ibanity.Billing.Xs2a.Report,
    "financialInstitutionStatus" => Ibanity.Billing.Xs2a.FinancialInstitutionStatus,
    "nbbReport" => Ibanity.Reporting.Xs2a.NbbReport,
    "nbbReportAiSynchronization" => Ibanity.Reporting.Xs2a.NbbReportAiSynchronization,
    "accountInformationAccessRequestAuthorization" =>
      Ibanity.Xs2a.AccountInformationAccessRequestAuthorization,
    "key" => Ibanity.Webhooks.Key,
    "xs2a.synchronization.succeededWithoutChange" =>
      Ibanity.Webhooks.Xs2a.Synchronization.SucceededWithoutChange,
    "xs2a.account.transactionsUpdated" => Ibanity.Webhooks.Xs2a.Account.TransactionsUpdated,
    "xs2a.account.transactionsCreated" => Ibanity.Webhooks.Xs2a.Account.TransactionsCreated,
    "xs2a.account.transactionsDeleted" => Ibanity.Webhooks.Xs2a.Account.TransactionsDeleted,
    "xs2a.account.pendingTransactionsUpdated" =>
      Ibanity.Webhooks.Xs2a.Account.PendingTransactionsUpdated,
    "xs2a.account.pendingTransactionsCreated" =>
      Ibanity.Webhooks.Xs2a.Account.PendingTransactionsCreated,
    "xs2a.synchronization.failed" => Ibanity.Webhooks.Xs2a.Synchronization.Failed,
    "xs2a.account.detailsUpdated" => Ibanity.Webhooks.Xs2a.Account.DetailsUpdated,
    "xs2a.bulkPaymentInitiationRequest.authorizationCompleted" =>
      Ibanity.Webhooks.Xs2a.BulkPaymentInitiationRequest.AuthorizationCompleted,
    "xs2a.paymentInitiationRequest.authorizationCompleted" =>
      Ibanity.Webhooks.Xs2a.PaymentInitiationRequest.AuthorizationCompleted,
    "xs2a.periodicPaymentInitiationRequest.authorizationCompleted" =>
      Ibanity.Webhooks.Xs2a.PeriodicPaymentInitiationRequest.AuthorizationCompleted,
    "xs2a.bulkPaymentInitiationRequest.statusUpdated" =>
      Ibanity.Webhooks.Xs2a.BulkPaymentInitiationRequest.StatusUpdated,
    "xs2a.paymentInitiationRequest.statusUpdated" =>
      Ibanity.Webhooks.Xs2a.PaymentInitiationRequest.StatusUpdated,
    "xs2a.periodicPaymentInitiationRequest.statusUpdated" =>
      Ibanity.Webhooks.Xs2a.PeriodicPaymentInitiationRequest.StatusUpdated,
    "pontoConnect.synchronization.succeededWithoutChange" =>
      Ibanity.Webhooks.PontoConnect.Synchronization.SucceededWithoutChange,
    "pontoConnect.synchronization.failed" => Ibanity.Webhooks.PontoConnect.Synchronization.Failed,
    "pontoConnect.account.detailsUpdated" => Ibanity.Webhooks.PontoConnect.Account.DetailsUpdated,
    "pontoConnect.account.transactionsCreated" =>
      Ibanity.Webhooks.PontoConnect.Account.TransactionsCreated,
    "pontoConnect.account.transactionsUpdated" =>
      Ibanity.Webhooks.PontoConnect.Account.TransactionsUpdated,
    "pontoConnect.account.pendingTransactionsCreated" =>
      Ibanity.Webhooks.PontoConnect.Account.PendingTransactionsCreated,
    "pontoConnect.account.pendingTransactionsUpdated" =>
      Ibanity.Webhooks.PontoConnect.Account.PendingTransactionsUpdated,
    "pontoConnect.account.reauthorized" => Ibanity.Webhooks.PontoConnect.Account.Reauthorized,
    "pontoConnect.organization.blocked" => Ibanity.Webhooks.PontoConnect.Organization.Blocked,
    "pontoConnect.organization.unblocked" => Ibanity.Webhooks.PontoConnect.Organization.Unblocked,
    "pontoConnect.integration.accountAdded" =>
      Ibanity.Webhooks.PontoConnect.Integration.AccountAdded,
    "pontoConnect.integration.accountRevoked" =>
      Ibanity.Webhooks.PontoConnect.Integration.AccountRevoked,
    "pontoConnect.integration.created" => Ibanity.Webhooks.PontoConnect.Integration.Created,
    "pontoConnect.integration.revoked" => Ibanity.Webhooks.PontoConnect.Integration.Revoked,
    "pontoConnect.paymentRequest.closed" => Ibanity.Webhooks.PontoConnect.PaymentRequest.Closed
  }

  def deserialize(item) do
    deserialize(item, nil)
  end

  def deserialize(item, nil) do
    deserialize(item, Map.fetch!(item, "type"))
  end

  def deserialize(item, resource_type) do
    return_type = return_type_module(resource_type)
    mapping = return_type.key_mapping()

    keys =
      Enum.map(mapping, fn
        {key, {fun, :function}} ->
          {key, fun.(item)}

        {key, {path, type}} ->
          {key, item |> get_in(path) |> deserialize_field(type)}
      end)

    struct(return_type, keys)
  end

  defp return_type_module(key) when is_bitstring(key), do: Map.fetch!(@type_mappings, key)
  defp return_type_module(module) when is_atom(module), do: module

  defp deserialize_field(nil, _), do: nil

  defp deserialize_field(field, :string) when is_list(field), do: field

  defp deserialize_field(field, type) when is_list(field) do
    Enum.map(field, &deserialize(&1, type))
  end

  defp deserialize_field(field, :datetime), do: DateTimeUtil.parse(field)

  defp deserialize_field(field, :date), do: Date.from_iso8601!(field)

  defp deserialize_field(field, _), do: field
end
