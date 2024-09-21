defmodule ExPitch.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ExPitch.PubSub,
      {ExPitch.PubSubListener,
       [
         ports: [
           keystep(),
           clock()
         ],
         name: ExPitch.PubSubListener
       ]},
      {ExPitch.Producer, ExPitch.port_by_name("IAC Driver Bus 1", :output)},
      {ExPitch.Clock, clock()},
      {ExPitch.DebugListener, nil},
      {ExPitch.Loop, nil}
    ]

    opts = [strategy: :one_for_one, name: ExPitch.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp keystep do
    ExPitch.port_by_name("Arturia KeyStep 32", :input)
  end

  defp clock do
    ExPitch.port_by_name("IAC Driver Clock", :input)
  end
end
