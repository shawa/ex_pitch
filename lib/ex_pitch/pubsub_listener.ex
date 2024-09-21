defmodule ExPitch.PubSubListener do
  use GenServer

  alias ExPitch.PubSub

  @impl GenServer
  @spec init([%Midiex.MidiPort{}]) :: {:ok, [%Midiex.MidiPort{}], {:continue, :subscribe_init}}
  def init(ports) do
    {:ok, ports, {:continue, :subscribe_init}}
  end

  @impl GenServer
  @spec handle_continue(:subscribe_init, [%Midiex.MidiPort{}]) :: {:noreply, [%Midiex.MidiPort{}]}
  def handle_continue(:subscribe_init, ports) do
    for port <- ports do
      Midiex.subscribe(port)
    end

    {:noreply, ports}
  end

  def start_link(ports: ports, name: name) do
    GenServer.start_link(__MODULE__, ports, name: name)
  end

  @impl GenServer
  def handle_info(msg, state) do
    :ok =
      PubSub.broadcast(
        {:midi, msg.port.name},
        msg
      )

    {:noreply, state}
  end
end
