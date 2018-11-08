defmodule Ibanity.Transaction do
  @moduledoc """
  Transactions API wrapper
  """

  use Ibanity.Resource

  defstruct [
    id: nil,
    value_date: nil,
    remittance_information_type: nil,
    remittance_information: nil,
    execution_date: nil,
    description: nil,
    currency: nil,
    counterpart_reference: nil,
    counterpart_name: nil,
    amount: nil,
    self: nil
  ]

  @api_schema_path ~w(customer financialInstitution transactions)

  def list(%Request{} = request) do
    request
    |> Request.id(:transactionId, "")
    |> Client.execute(:get, @api_schema_path, __MODULE__)
  end

  def find(%Request{} = request) do
    request
    |> Client.execute(:get, @api_schema_path, __MODULE__)
  end

  def key_mapping do
    [
      id: ~w(id),
      value_date: ~w(attributes valueDate),
      remittance_information_type: ~w(attributes remittanceInformationType),
      remittance_information: ~w(attributes remittanceInformation),
      execution_date: ~w(attributes executionDate),
      description: ~w(attributes description),
      currency: ~w(attributes currency),
      counterpart_reference: ~w(attributes counterpartReference),
      counterpart_name: ~w(attributes counterpartName),
      amount: ~w(attributes amount),
      self: ~w(links self)
    ]
  end
end
