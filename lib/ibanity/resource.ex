defmodule Ibanity.Resource do
  @moduledoc false

  defmacro __using__(_ \\ []) do
    quote do
      alias Ibanity.Client
      alias Ibanity.Request
      alias unquote(__MODULE__)
    end
  end
end
