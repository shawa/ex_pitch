defmodule ExPitch.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ExPitch.PubSub.Clock,
      ExPitch.PubSub.MIDI,
      {ExPitch.Clock, {:genserver, 60}},
      # {ExPitch.Sequencer, 4},
      {ExPitch.MIDI.Producer, ExPitch.port_by_name("IAC Driver Bus 1", :output)}
    ]

    opts = [strategy: :one_for_one, name: ExPitch.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
