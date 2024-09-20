defmodule ExPitch.Listener do
  alias Midiex.Listener
  use GenServer

  def init(_) do
    {:ok, nil}
  end

  def start_link(port) do
    {:ok, listener} = Listener.start_link(port: port)

    Listener.add_handler(listener, fn message ->
      IO.inspect(message)
    end)

    {:ok, self()}
  end
end
