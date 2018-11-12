defmodule Ibanity.ResourceIdentifierTest do
  use ExUnit.Case, async: true
  import Ibanity.ResourceIdentifier

  describe ".substitute_in_uri/1" do
    test "return an error if there are missing ids" do
      uri = "http://www.example.com/{financialInstitutionId}"
      resource_ids = []

      assert substitute_in_uri(uri, resource_ids) == {:error, :missing_ids}
    end

    test "substitute all the ids" do
      uri = "http://www.example.com/{financialInstitutionId}/accounts/{accountId}"
      resource_ids = [
        financialInstitutionId: "287d7357-bbe8-455c-89f6-a83c111b1f93",
        accountId: "59f86484-6503-42e2-9e0b-de28cc1b7a0c"
      ]

      assert substitute_in_uri(uri, resource_ids) ==
        {:ok, "http://www.example.com/287d7357-bbe8-455c-89f6-a83c111b1f93/accounts/59f86484-6503-42e2-9e0b-de28cc1b7a0c"}
    end

    test "allow empty ids" do
      uri = "http://www.example.com/{financialInstitutionId}/accounts/{accountId}"
      resource_ids = [
        financialInstitutionId: "287d7357-bbe8-455c-89f6-a83c111b1f93",
        accountId: ""
      ]

      assert substitute_in_uri(uri, resource_ids) ==
        {:ok, "http://www.example.com/287d7357-bbe8-455c-89f6-a83c111b1f93/accounts/"}
    end
  end
end
