defmodule Ibanity.ApiSchema do
  @moduledoc false
  use Retry
  alias Ibanity.IdReplacer
  import Ibanity.Signature, only: [signature_headers: 5]

  @base_headers [
    {"Accept", "application/json"},
    {"Content-Type", "application/json"}
  ]

  def fetch("https://api.ibanity.com/xs2a", _, :test) do
    %{
      "customer" => %{
        "accounts" => "https://api.ibanity.com/customer/accounts",
        "financialInstitution" => %{
          "accountInformationAccessRequests" =>
            "https://api.ibanity.com/customer/financial-institutions/{financial_institution_id}/account-information-access-requests/{id}",
          "accounts" =>
            "https://api.ibanity.com/customer/financial-institutions/{financial_institution_id}/accounts/{id}",
          "paymentInitiationRequests" =>
            "https://api.ibanity.com/customer/financial-institutions/{financial_institution_id}/payment-initiation-requests/{id}",
          "transactions" =>
            "https://api.ibanity.com/customer/financial-institutions/{financial_institution_id}/accounts/{account_id}/transactions/{id}",
          "accountInformationAccessRequest" => %{
            "accounts" => "https://api.ibanity.com/customer/financial-institutions/{financial_institution_id}/account-information-access-requests/{account_information_access_request_id}/accounts",
          }
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
            "financialInstitutionTransactions" =>
              "https://api.ibanity.com/sandbox/financial-institutions/{financial_institution_id}/financial-institution-users/{financial_institution_user_id}/financial-institution-accounts/{financial_institution_account_id}/financial-institution-transactions/{id}"
          },
          "financialInstitutionAccounts" =>
            "https://api.ibanity.com/sandbox/financial-institutions/{financial_institution_id}/financial-institution-users/{financial_institution_user_id}/financial-institution-accounts/{id}"
        },
        "financialInstitutionUsers" =>
          "https://api.ibanity.com/sandbox/financial-institution-users/{id}",
        "financialInstitutions" => "https://api.ibanity.com/sandbox/financial-institutions/{id}"
      }
    }
  end

  def fetch("https://api.ibanity.com/sandbox", _, :test) do
    %{
      "financialInstitution" => %{
        "financialInstitutionAccount" => %{
          "financialInstitutionTransactions" =>
            "https://api.ibanity.com/sandbox/financial-institutions/{financial_institution_id}/financial-institution-users/{financial_institution_user_id}/financial-institution-accounts/{financial_institution_account_id}/financial-institution-transactions/{id}"
        },
        "financialInstitutionAccounts" =>
          "https://api.ibanity.com/sandbox/financial-institutions/{financial_institution_id}/financial-institution-users/{financial_institution_user_id}/financial-institution-accounts/{id}"
      },
      "financialInstitutionUsers" =>
        "https://api.ibanity.com/sandbox/financial-institution-users/{id}",
      "financialInstitutions" => "https://api.ibanity.com/sandbox/financial-institutions/{id}"
    }
  end

  def fetch("https://api.ibanity.com/consent", _, :test) do
    %{
      "consent" => %{
        "processingOperations" =>
            "https://api.ibanity.com/consent/consents/{consent_id}/processing-operations",
        "validations" =>
          "https://api.ibanity.com/consent/consents/{consent_id}/validations",
      },
      "consents" => "https://api.ibanity.com/consent/consents/{id}"
    }
  end

  def fetch("https://api.ibanity.com/billing", _, :test) do
    %{
      "customer" => %{
        "xs2aReport" =>
            "https://api.ibanity.com/billing/customer/{application_customer_reference}/xs2a-report"
      }
    }
  end

  def fetch(api_url, app_options, _) do
    res = fetch_api_schema(api_url, app_options)

    res.body
    |> Jason.decode!()
    |> Map.fetch!("links")
    |> apply_to_values(fn str ->
      str
      |> IdReplacer.replace_all(&Recase.to_snake/1)
      |> IdReplacer.replace_last()
    end)
  end

  defp fetch_api_schema(api_url, app_options) do
    retry with: backoff(), rescue_only: [HTTPoison.Error] do
      url = api_url <> "/"
      res = HTTPoison.get!(url, headers(url, app_options.signature), ssl: app_options.ssl, hackney: [pool: :default])

      handle_response(res)
    after
      result -> result
    else
      _ -> raise HTTPoison.Error, reason: :timeout
    end
  end

  defp headers(_, nil), do: @base_headers
  defp headers(url, signature_options) do
    key = Keyword.get(signature_options, :signature_key)
    certificate_id = Keyword.get(signature_options, :certificate_id)
    {:ok, signature_headers} = signature_headers(url, :get, nil, key, certificate_id)

    @base_headers ++ signature_headers
  end

  # Try maximum 5 times with a delay between attempts
  # starting at 1s and increasing 500ms each time.
  # Note that request has a default timeout of 5s.
  defp backoff, do: 1000 |> linear_backoff(500) |> Stream.take(5)

  defp handle_response(response) do
    code = response.status_code
    cond do
      code in 200..499 ->
        response

      code in 500..599 ->
        raise HTTPoison.Error

      true ->
        raise HTTPoison.Error
    end
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
