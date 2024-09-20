defmodule ExPitch.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {ExPitch.Listener, ExPitch.port_by_name("Arturia KeyStep 32", :input)},
      {ExPitch.Producer, ExPitch.port_by_name("IAC Driver Bus 1", :output)}
    ]

    opts = [strategy: :one_for_one, name: ExPitch.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
