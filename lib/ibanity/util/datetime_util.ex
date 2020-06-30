defmodule Ibanity.DateTimeUtil do
  @moduledoc false

  def parse(string) do
    case DateTime.from_iso8601(string) do
      {:ok, datetime, 0} ->
        datetime

      {:error, _} ->
        raise ArgumentError, message: "cannot parse #{string} as datetime"
    end
  end
end
