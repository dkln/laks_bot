defmodule LaksBot do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      
    ]

    IO.puts "Starting servert"

    opts = [strategy: :one_for_one, name: LaksBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
