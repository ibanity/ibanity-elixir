defmodule Ibanity.ApiSchema do
  @moduledoc """
  API Schema retriever, with support for hardcoded schema, for test environment
  """
  alias Ibanity.IdReplacer

  @base_headers [
    {"Accept", "application/json"},
    {"Content-Type", "application/json"}
  ]

  def fetch(_, :test) do
    %{
      "customer" => %{
        "accounts" => "https://api.ibanity.localhost/customer/accounts",
        "financialInstitution" => %{
          "accountInformationAccessRequests" => "https://api.ibanity.localhost/customer/financial-institutions/{financialInstitutionId}/account-information-access-requests",
          "accounts" => "https://api.ibanity.localhost/customer/financial-institutions/{financialInstitutionId}/accounts/{id}",
          "paymentInitiationRequests" => "https://api.ibanity.localhost/customer/financial-institutions/{financialInstitutionId}/payment-initiation-requests/{id}",
          "transactions" => "https://api.ibanity.localhost/customer/financial-institutions/{financialInstitutionId}/accounts/{accountId}/transactions/{id}"
        },
        "financialInstitutions" => "https://api.ibanity.localhost/customer/financial-institutions",
        "self" => "https://api.ibanity.localhost/customer",
        "synchronizations" => "https://api.ibanity.localhost/customer/synchronizations/{id}"
      },
      "customerAccessTokens" => "https://api.ibanity.localhost/customer-access-tokens",
      "financialInstitutions" => "https://api.ibanity.localhost/financial-institutions/{id}",
      "sandbox" => %{
        "financialInstitution" => %{
          "financialInstitutionAccount" => %{
            "financialInstitutionTransactions" => "https://api.ibanity.localhost/sandbox/financial-institutions/{financialInstitutionId}/financial-institution-users/{financialInstitutionUserId}/financial-institution-accounts/{financialInstitutionAccountId}/financial-institution-transactions/{id}"
          },
          "financialInstitutionAccounts" => "https://api.ibanity.localhost/sandbox/financial-institutions/{financialInstitutionId}/financial-institution-users/{financialInstitutionUserId}/financial-institution-accounts/{id}"
        },
        "financialInstitutionUsers" => "https://api.ibanity.localhost/sandbox/financial-institution-users/{id}",
        "financialInstitutions" => "https://api.ibanity.localhost/sandbox/financial-institutions/{id}"
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
    |> replace_last_ids
  end

  defp replace_last_ids(links) when is_map(links) do
    Enum.reduce(links, %{}, fn {key, value}, acc ->
      Map.put_new(acc, key, replace_last_ids(value))
    end)
  end
  defp replace_last_ids(str) when is_binary(str) do
    IdReplacer.replace_last(str)
  end
end
