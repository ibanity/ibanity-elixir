defmodule Ibanity.IdReplacer do
  @moduledoc """
  Utilities for replacing last id in a URI template with the word 'Id'
  """

  @id_regex ~r/\{[^\}]*\}/

  @doc ~S"""
  Replace all ids in a URI template by the result of the given function

  ## Examples

    iex> url = "https://api.ibanity.com/customer/synchronizations/{synchronizationId}"
    ...> Ibanity.IdReplacer.replace_all(url, &String.upcase/1)
    "https://api.ibanity.com/customer/synchronizations/{SYNCHRONIZATIONID}"

    iex> url = "https://api.ibanity.com/customer/synchronizations"
    ...> Ibanity.IdReplacer.replace_all(url, &String.replace("*", String.length(&1)))
    "https://api.ibanity.com/customer/synchronizations"

    iex> url = "https://api.ibanity.com/customer/financial-institutions/{financialInstitutionId}/accounts/{accountId}"
    ...> Ibanity.IdReplacer.replace_all(url, &Recase.to_snake/1)
    "https://api.ibanity.com/customer/financial-institutions/{financial_institution_id}/accounts/{account_id}"
  """

  def replace_all(url, func) do
    @id_regex
    |> Regex.scan(url)
    |> List.flatten
    |> Enum.reduce(url, fn to_replace, new_url ->
      placeholder = to_replace
      to_replace = Regex.replace(~r/(\{|\})/, to_replace, "")
      String.replace(new_url, placeholder, "{" <> func.(to_replace) <> "}")
    end)
  end

  @doc ~S"""
  Replace the last occurence of an id in a URI template with `{id}`. If the URI ends with a slash (`/`)
  it is automatically removed

  ## Examples

    iex> url = "https://api.ibanity.com/customer/synchronizations/{synchronizationId}"
    ...> Ibanity.IdReplacer.replace_last(url)
    "https://api.ibanity.com/customer/synchronizations/{id}"

    iex> url = "https://api.ibanity.com/customer/synchronizations/{synchronizationId}/"
    ...> Ibanity.IdReplacer.replace_last(url)
    "https://api.ibanity.com/customer/synchronizations/{id}"

    iex> url = "https://api.ibanity.com/customer/synchronizations"
    ...> Ibanity.IdReplacer.replace_last(url)
    "https://api.ibanity.com/customer/synchronizations"

    iex> url = "https://api.ibanity.com/customer/financial-institutions/{financialInstitutionId}/accounts/{accountId}"
    ...> Ibanity.IdReplacer.replace_last(url)
    "https://api.ibanity.com/customer/financial-institutions/{financialInstitutionId}/accounts/{id}"
  """

  def replace_last(url) do
    url
    |> String.split("/")
    |> Enum.reverse
    |> replace_id
    |> Enum.reverse
    |> Enum.join("/")
  end

  defp replace_id(["", segment | rest]) do
    replace_id([segment | rest])
  end
  defp replace_id([segment | rest] = split_url) do
    if Regex.match?(@id_regex, segment), do: ["{id}" | rest], else: split_url
  end
end
