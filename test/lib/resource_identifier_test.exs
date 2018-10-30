defmodule Ibanity.ResourceIdentifierTest do
  use ExUnit.Case, async: true
  import Ibanity.ResourceIdentifier

  test "valid when mandatory identifiers are present" do
    expected_ids = [:financialInstitution, :customer]
    actual_ids = [
      financialInstitution: "d15563b2-9f6a-4ede-8f9a-fb6de858c382",
      customer: "2250d435-1c78-4080-89e5-1bc052ae6df6"
    ]

    assert validate_ids(expected_ids, actual_ids) == {:ok, actual_ids}
  end

  test "error when identifiers are missing" do
    expected_ids = [:financialInstitution, :customer]
    actual_ids = [
      financialInstitution: "d15563b2-9f6a-4ede-8f9a-fb6de858c382"
    ]

    assert validate_ids(expected_ids, actual_ids) == {:error, :missing_resource_ids}
  end

  test "error when identifiers are not UUIDv4" do
    expected_ids = [:financialInstitution, :customer]

    # "af42e939-7e21-5397-b8fe-4743cfe62ad8" is not a UUIDv4
    actual_ids = [
      financialInstitution: "af42e939-7e21-5397-b8fe-4743cfe62ad8",
      customer: "2250d435-1c78-4080-89e5-1bc052ae6df6"
    ]

    assert validate_ids(expected_ids, actual_ids) == {:error, :invalid_resource_id}
  end
end
