defmodule LaksBot do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(LaksBot.Worker, [])
    ]

    opts = [strategy: :one_for_one, name: LaksBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
