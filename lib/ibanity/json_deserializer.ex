defmodule Ibanity.JsonDeserializer do
  @moduledoc false
  alias Ibanity.DateTimeUtil

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
