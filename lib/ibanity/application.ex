defmodule Ibanity.Application do
  @moduledoc false
  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    children = [
      worker(Ibanity.Configuration, [Application.get_all_env(:ibanity)])
    ]

    opts = [strategy: :one_for_one, name: Ibanity.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
