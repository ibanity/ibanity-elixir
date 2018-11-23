defmodule Ibanity.JsonDeserializer do
  @moduledoc false

  @type_mappings %{
    "accountInformationAccessRequest" => Ibanity.AccountInformationAccessRequest,
    "account" => Ibanity.Account,
    "customerAccessToken" => Ibanity.CustomerAccessToken,
    "customer" => Ibanity.Customer,
    "financialInstitutionTransaction" => Ibanity.FinancialInstitutionTransaction,
    "financialInstitutionAccount" => Ibanity.FinancialInstitutionAccount,
    "financialInstitutionUser" => Ibanity.FinancialInstitutionUser,
    "financialInstitution" => Ibanity.FinancialInstitution,
    "paymentInitiationRequest" => Ibanity.PaymentInitiationRequest,
    "transaction" => Ibanity.Transaction,
    "synchronization" => Ibanity.Synchronization
  }

  def deserialize(item) do
    return_type = Map.fetch!(@type_mappings, Map.fetch!(item, "type"))
    mapping = return_type.key_mapping()
    keys = Enum.map(mapping, fn {key, path} -> {key, get_in(item, path)} end)

    struct(return_type, keys)
  end
end
