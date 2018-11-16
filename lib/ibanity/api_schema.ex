defmodule Ibanity.ApiSchema do
  @moduledoc false

  alias Ibanity.IdReplacer

  @base_headers [
    {"Accept", "application/json"},
    {"Content-Type", "application/json"}
  ]

  def fetch(_, :test) do
    %{
      "customer" => %{
        "accounts" => "https://api.ibanity.com/customer/accounts",
        "financialInstitution" => %{
          "accountInformationAccessRequests" => "https://api.ibanity.com/customer/financial-institutions/{financial_institution_id}/account-information-access-requests",
          "accounts" => "https://api.ibanity.com/customer/financial-institutions/{financial_institution_id}/accounts/{id}",
          "paymentInitiationRequests" => "https://api.ibanity.com/customer/financial-institutions/{financial_institution_id}/payment-initiation-requests/{id}",
          "transactions" => "https://api.ibanity.com/customer/financial-institutions/{financial_institution_id}/accounts/{account_id}/transactions/{id}"
        },
        "financialInstitutions" => "https://api.ibanity.com/customer/financial-institutions",
        "self" => "https://api.ibanity.com/customer",
        "synchronizations" => "https://api.ibanity.com/customer/synchronizations/{id}"
      },
      "customerAccessTokens" => "https://api.ibanity.com/customer-access-tokens",
      "financialInstitutions" => "https://api.ibanity.com/financial-institutions/{id}",
      "sandbox" => %{
        "financialInstitution" => %{
          "financialInstitutionAccount" => %{
            "financialInstitutionTransactions" => "https://api.ibanity.com/sandbox/financial-institutions/{financial_institution_id}/financial-institution-users/{financial_institution_user_id}/financial-institution-accounts/{financial_institution_account_id}/financial-institution-transactions/{id}"
          },
          "financialInstitutionAccounts" => "https://api.ibanity.com/sandbox/financial-institutions/{financial_institution_id}/financial-institution-users/{financial_institution_user_id}/financial-institution-accounts/{id}"
        },
        "financialInstitutionUsers" => "https://api.ibanity.com/sandbox/financial-institution-users/{id}",
        "financialInstitutions" => "https://api.ibanity.com/sandbox/financial-institutions/{id}"
      }
    }
  end
  def fetch(config, _) do
    res = HTTPoison.get!(
      config.api_url <> "/",
      @base_headers,
      ssl: config.ssl_options
    )

    res.body
    |> Jason.decode!
    |> Map.fetch!("links")
    |> apply_to_values(fn str ->
      str
      |> IdReplacer.replace_all(&Recase.to_snake/1)
      |> IdReplacer.replace_last
    end)
  end

  defp apply_to_values(links, func) when is_map(links) do
    Enum.reduce(links, %{}, fn {key, value}, acc ->
      Map.put_new(acc, key, apply_to_values(value, func))
    end)
  end
  defp apply_to_values(str, func) when is_binary(str) do
    func.(str)
  end
end
