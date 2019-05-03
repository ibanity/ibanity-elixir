defmodule Ibanity.Xs2a.Customer.DeserializationTest do
  use ExUnit.Case
  import Ibanity.JsonDeserializer
  alias Ibanity.Xs2a.Customer

  test "deserialize a customer" do
    data = %{
      "type" => "customer",
      "id" => "27407a42-b3a3-44ed-8aea-cd7f90b85f65"
    }

    actual = data |> deserialize

    expected = %Customer{
      id: "27407a42-b3a3-44ed-8aea-cd7f90b85f65"
    }

    assert actual == expected
  end
end
