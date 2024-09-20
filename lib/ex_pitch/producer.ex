defmodule ExPitch.Producer do
  use GenServer

  alias ExPitch.Note

  @impl GenServer
  @spec init(%Midiex.MidiPort{}) :: {:ok, %Midiex.OutConn{}}
  def init(port) do
    out_conn = Midiex.open(port)
    {:ok, out_conn}
  end

  @spec start_link(%Midiex.MidiPort{}) :: {:ok, pid()}
  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl GenServer
  def handle_info(msg, out_conn) do
    Midiex.send_msg(out_conn, msg)
    {:noreply, out_conn}
  end

  @impl GenServer
  def handle_cast({:play_one, note}, out_conn) do
    send(__MODULE__, Midiex.Message.note_on(note))
    Process.send_after(__MODULE__, Midiex.Message.note_off(note), 1000)
    {:noreply, out_conn}
  end

  def handle_cast({:play, notes}, out_conn) do
    Enum.each(notes, fn note ->
      send(__MODULE__, Midiex.Message.note_on(note))
      Process.send_after(__MODULE__, Midiex.Message.note_off(note), 1000)
    end)

    {:noreply, out_conn}
  end

  @spec play(Note.t() | [Note.t()]) :: :ok
  def play(notes) when is_list(notes) do
    GenServer.cast(__MODULE__, {:play, notes})
  end

  def play(note) when is_atom(note) or is_integer(note) do
    GenServer.cast(__MODULE__, {:play_one, note})
  end
end
