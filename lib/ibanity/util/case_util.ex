defmodule Ibanity.CaseUtil do
  @moduledoc """
  Utilities for transforming from one case to another
  """

  @doc ~S"""
  Transform an atom into its camel case representation

  ## Examples

    iex> Ibanity.CaseUtil.to_camel(:financial_institution_id)
    :financialInstitutionId

    iex> Ibanity.CaseUtil.to_camel("financial_institution_id")
    "financialInstitutionId"

    iex> Ibanity.CaseUtil.to_camel(financial_institution_id: "1")
    [financialInstitutionId: "1"]

    iex> Ibanity.CaseUtil.to_camel(%{financial_institution_id: "1"})
    %{financialInstitutionId: "1"}
  """

  def to_camel(term) when is_atom(term) do
    term
    |> Atom.to_string
    |> Recase.to_camel
    |> String.to_atom
  end
  def to_camel(term) when is_list(term) do
    Enum.map(term, fn {key, value} -> {to_camel(key), value} end)
  end
  def to_camel(term) when is_map(term) do
    Enum.reduce(term, %{}, fn {key, value}, acc -> Map.put_new(acc, to_camel(key), value) end)
  end
  def to_camel(term) when is_binary(term) do
    Recase.to_camel(term)
  end
end