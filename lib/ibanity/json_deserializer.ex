defmodule Ibanity.JsonDeserializer do
  @moduledoc false
  alias Ibanity.DateTimeUtil

  @type_mappings %{
    "accountInformationAccessRequest" => Ibanity.Xs2a.AccountInformationAccessRequest,
    "account" => Ibanity.Xs2a.Account,
    "customerAccessToken" => Ibanity.Xs2a.CustomerAccessToken,
    "customer" => Ibanity.Xs2a.Customer,
    "financialInstitutionTransaction" => Ibanity.Sandbox.FinancialInstitutionTransaction,
    "financialInstitutionAccount" => Ibanity.Sandbox.FinancialInstitutionAccount,
    "financialInstitutionUser" => Ibanity.Sandbox.FinancialInstitutionUser,
    "financialInstitution" => Ibanity.Xs2a.FinancialInstitution,
    "paymentInitiationRequest" => Ibanity.Xs2a.PaymentInitiationRequest,
    "transaction" => Ibanity.Xs2a.Transaction,
    "synchronization" => Ibanity.Xs2a.Synchronization,
    "consent" => Ibanity.Consent.Consent,
    "processingOperation" => Ibanity.Consent.ProcessingOperation,
    "xs2aReport" => Ibanity.Billing.Xs2aReport
  }

  def deserialize(item) do
    return_type = Map.fetch!(@type_mappings, Map.fetch!(item, "type"))
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
