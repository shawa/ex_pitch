defmodule ExPitch.Clock.MIDI do
  use GenServer
  require Logger

  alias ExPitch.PubSub.Clock

  def init(port) do
    {:ok, port, {:continue, :subscribe_ports}}
  end

  def handle_continue(:subscribe_ports, port) do
    Midiex.subscribe(port)

    {:noreply, nil}
  end

  def start_link(port) do
    GenServer.start_link(__MODULE__, port, name: __MODULE__)

    {:ok, self()}
  end

  def handle_info(%{data: [250]}, state) do
    Clock.broadcast(:start)
    Clock.broadcast(:tick)
    {:noreply, state}
  end

  def handle_info(%{data: [248]}, state) do
    Clock.broadcast(:tick)
    {:noreply, state}
  end

  def handle_info(%{data: [252]}, state) do
    Clock.broadcast(:stop)
    {:noreply, state}
  end
end
