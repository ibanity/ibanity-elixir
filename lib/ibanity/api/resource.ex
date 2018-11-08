defmodule Ibanity.Resource do
  @moduledoc """
  Common properties for resources
  """
  defmacro __using__(_ \\ []) do
    quote do
      alias Ibanity.Client
      alias Ibanity.Request
      alias unquote(__MODULE__)
    end
  end
end
