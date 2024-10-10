defmodule Ibanity.PontoConnect.CommonDocs do
  @moduledoc false

  @common_docs %{
    client_token: """
    **NOTE:** This resource needs a client token!

    See `Ibanity.PontoConnect.Token.create/1` to find out how to request a client token.
    """,
    account_id: """
    Fetch an account before each example, or use a valid account id

        iex> {:ok, account_or_id} = token |> Ibanity.PontoConnect.Account.find("03ebe0ae-f630-4414-b37b-afde7de67229")

    Or

        iex> account_or_id = "03ebe0ae-f630-4414-b37b-afde7de67229"
        "03ebe0ae-f630-4414-b37b-afde7de67229"
    """,
    synchronization_id: """
    Fetch a synchronization before each example, or use a valid synchronization id

        iex> {:ok, synchronization_or_id} = token |> Ibanity.PontoConnect.Suynchronization.find("03ebe0ae-f630-4414-b37b-afde7de67229")

    Or

        iex> synchronization_or_id = "03ebe0ae-f630-4414-b37b-afde7de67229"
        "03ebe0ae-f630-4414-b37b-afde7de67229"
    """,
    financial_institution_id: """
    Fetch a financial institution before each example, or use a valid financial institution id

        iex> {:ok, financial_institution_or_id} = Ibanity.PontoConnect.FinancialInstitution.find_public("953934eb-229a-4fd2-8675-07794078cc7d")

    Or

        iex> financial_institution_or_id = "953934eb-229a-4fd2-8675-07794078cc7d"
        "953934eb-229a-4fd2-8675-07794078cc7d"
    """,
    financial_institution_and_account_ids: """
    Fetch a financial institution and financial institution account before each example, or use a valid financial institution id

        iex> {:ok, financial_institution_or_id} = Ibanity.PontoConnect.FinancialInstitution.find_public(
        ...>   "953934eb-229a-4fd2-8675-07794078cc7d"
        ...> )
        iex> {:ok, financial_institution_account_or_id} = Ibanity.PontoConnect.Sandbox.FinancialInstitutionAccount.find(
        ...>   token,
        ...>   %{
        ...>     financial_institution_id: financial_institution_or_id,
        ...>     id: "cb0bb5ab-dc3d-4832-b2ff-e6629240732f"
        ...>   }
        ...> )

    Or

        iex> financial_institution_or_id = "953934eb-229a-4fd2-8675-07794078cc7d"
        iex> financial_institution_account_or_id = "cb0bb5ab-dc3d-4832-b2ff-e6629240732f"
    """,
    account_and_id_second_arg: """
    Takes a map with the following keys as second argument:
    - `:account_id`: `Ibanity.PontoConnect.Account` struct or account ID as a string
    - `:id`: resource ID as a string
    """,
    financial_institution_and_id_second_arg: """
    Takes a map with the following keys as second argument:
    - `:financial_institution_id`: `Ibanity.PontoConnect.Sandbox.FinancialInstitution` struct or account ID as a string
    - `:id`: resource ID as a string
    """,
    financial_institution_and_account_second_arg: """
    Takes a map with the following keys as second argument:
    - `:financial_institution_id`: `Ibanity.PontoConnect.FinancialInstitution` struct or account ID as a string
    - `:financial_institution_account_id`: `Ibanity.PontoConnect.Sandbox.FinancialInstitutionAccount` struct or account ID as a string
    - `:id`: resource ID as a string
    """
  }

  @doc false
  def fetch!(key), do: Map.fetch!(@common_docs, key)
end
