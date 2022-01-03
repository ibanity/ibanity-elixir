defmodule Ibanity.WebhookHandler do
  @moduledoc """
  Webhook handler specification.
  See `Ibanity.WebhookPlug` for more details.
  """

  @doc "Handles an Ibanity webhook event within your application."
  @callback handle_event(event :: Struct) :: {:ok, term} | :ok
end
