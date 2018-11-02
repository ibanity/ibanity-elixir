defmodule Ibanity.Resource do
  defmacro __using__(_ \\ []) do
    quote do
      alias Ibanity.Client.Request, as: ClientRequest
      alias Ibanity.{Request, ResourceOperations}
      alias unquote(__MODULE__)
    end
  end
end