defmodule Ibanity.Resource do
  @moduledoc """
  Common properties for resources
  """
  defmacro __using__(_ \\ []) do
    quote do
      alias Ibanity.HttpRequest
      alias Ibanity.{Client, Request}
      alias unquote(__MODULE__)
    end
  end
end
