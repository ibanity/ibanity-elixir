defmodule Ibanity.WebhookPlug do
  @moduledoc """
  Helper `Plug` to process webhook events and send them to a custom handler.
  ## Installation
  To handle webhook events, you must first configure your application's endpoint.
  Add the following to `endpoint.ex`, **before** `Plug.Parsers` is loaded.
  ```elixir
  plug Ibanity.WebhookPlug,
    at: "/webhook/ibanity",
    handler: MyAppWeb.IbanityHandler
  ```
  ### Supported options
  - `at`: The URL path your application should listen for Ibanity webhooks on.
    Configure this to match whatever you set in the Ibanity Developer Portal.
  - `handler`: Custom event handler module that accepts Ibanity event structs
    and processes them within your application. You must create this module.
  - `tolerance`: Maximum drift (in seconds) allowed for the webhook event
    timestamps. See `Ibanity.Webhook.construct_event/5` for more information.
  - `application`: Application configuration which should be used to fetch the
    webhook signing keys. See `Ibanity.Webhook.construct_event/5` for more
    information.
  ## Handling events
  You will need to create a custom event handler module to handle events.
  Your event handler module should implement the `Ibanity.WebhookHandler`
  behavior, defining a `handle_event/1` function which takes an Ibanity event
  struct and returns either `{:ok, term}` or `:ok`.
  ### Example
  ```elixir
  # lib/myapp_web/ibanity_handler.ex
  defmodule MyAppWeb.IbanityHandler do
    @behaviour Ibanity.WebhookHandler
    alias Ibanity.Webhooks.Xs2a.Synchronization
    @impl true
    def handle_event(%Synchronization.DetailsUpdated{} = event) do
      # TODO: handle the xs2a.synchronization.detailsUpdated event
    end
    @impl true
    def handle_event(%Synchronization.Failed{} = event) do
      # TODO: handle the xs2a.synchronization.failed event
    end
    # Return HTTP 200 for unhandled events
    @impl true
    def handle_event(_event), do: :ok
  end
  ```
  """

  import Plug.Conn
  alias Plug.Conn

  @behaviour Plug

  @impl true
  def init(opts) do
    path_info = String.split(opts[:at], "/", trim: true)

    opts
    |> Enum.into(%{})
    |> Map.put_new(:path_info, path_info)
    |> Map.put_new(:application, :default)
  end

  @impl true
  def call(%Conn{method: "POST", path_info: path_info} = conn, %{path_info: path_info, handler: handler} = opts) do
    with [signature] <- get_req_header(conn, "signature"),
         {:ok, payload, _} = Conn.read_body(conn),
         {:ok, %{} = event} <- construct_event(conn.host <> conn.request_path, payload, signature, opts),
         :ok <- handle_event!(handler, event) do
      send_resp(conn, 200, "Webhook received.") |> halt()
    else
      _ -> send_resp(conn, 400, "Bad request.") |> halt()
    end
  end

  @impl true
  def call(%Conn{path_info: path_info} = conn, %{path_info: path_info}) do
    send_resp(conn, 400, "Bad request.") |> halt()
  end

  @impl true
  def call(conn, _), do: conn

  defp construct_event(url, payload, signature, %{application: application, tolerance: tolerance}) do
    Ibanity.Webhook.construct_event(url, payload, signature, application, tolerance)
  end

  defp construct_event(url, payload, signature, %{application: application}) do
    Ibanity.Webhook.construct_event(url, payload, signature, application)
  end

  defp handle_event!(handler, %{} = event) do
    case handler.handle_event(event) do
      {:ok, _} ->
        :ok

      :ok ->
        :ok

      resp ->
        raise """
        #{inspect(handler)}.handle_event/1 returned an invalid response. Expected {:ok, term} or :ok
        Got: #{inspect(resp)}
        Event data: #{inspect(event)}
        """
    end
  end
end
