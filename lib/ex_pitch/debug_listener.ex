defmodule ExPitch.DebugListener do
  require Logger

  alias ExPitch.PubSub

  use GenServer

  def init(_) do
    {:ok, nil, {:continue, :subscribe_midi}}
  end

  def handle_continue(:subscribe_midi, nil) do
    PubSub.subscribe({:midi, "Arturia KeyStep 32"})
    PubSub.subscribe(:clock)
    {:noreply, nil}
  end

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def handle_info(msg, state) do
    Logger.debug(inspect(msg))
    {:noreply, state}
  end
end
