defmodule Ibanity.PontoConnect.Exceptions do
  @moduledoc false

  @doc false
  def token_argument_error_msg(resource_name, other) do
    """
    Cannot access #{resource_name} with given arguments.
    Expected one of:
    - `%Ibanity.Request{}` with `:token` set
    - `%Ibanity.PontoConnect.Token{}`

    Got: #{inspect(other)}
    """
  end
end
