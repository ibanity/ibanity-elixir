defmodule Ibanity.ResourceIdentifier do

  def validate_ids(expected_ids, actual_ids) do
    with :ok <- validate_presence(expected_ids, actual_ids),
         :ok <- actual_ids |> Keyword.values |> validate_uuids
      do
        {:ok, actual_ids}
      else
        reason -> {:error, reason}
    end
  end

  defp validate_presence(expected_ids, actual_ids) do
    case Enum.all?(expected_ids, &(Keyword.has_key?(actual_ids, &1))) do
      true  -> :ok
      false -> :missing_resource_ids
    end
  end

  defp validate_uuids(ids) do
    case Enum.all?(ids, &uuidv4?/1) do
      true  -> :ok
      false -> :invalid_resource_id
    end
  end

  defp uuidv4?(uuid) do
    case UUID.info(uuid) do
      {:ok, info}
        -> Keyword.get(info, :version) == 4
      {:error, _}
        -> false
    end
  end
end
