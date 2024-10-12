defmodule ExPitch.MIDI.Producer do
  use GenServer

  alias ExPitch.Note

  require Logger

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
    Logger.debug(inspect(msg))
    Midiex.send_msg(out_conn, msg)
    {:noreply, out_conn}
  end

  @impl GenServer
  def handle_cast({:play, notes, :forever}, out_conn) do
    Enum.each(notes, fn note ->
      send(__MODULE__, Midiex.Message.note_on(note))
    end)

    {:noreply, out_conn}
  end

  def handle_cast({:play, notes, release}, out_conn) do
    Enum.each(notes, fn note ->
      send(__MODULE__, Midiex.Message.note_on(note))
      Process.send_after(__MODULE__, Midiex.Message.note_off(note), release)
    end)

    {:noreply, out_conn}
  end

  def handle_cast({:halt, notes}, out_conn) do
    Enum.each(notes, fn note ->
      send(__MODULE__, Midiex.Message.note_off(note))
    end)

    {:noreply, out_conn}
  end

  @spec play(Note.t() | [Note.t()], integer() | :forever) :: :ok
  def play(note_or_notes, release \\ 800)

  def play(note_or_notes, release) do
    GenServer.cast(__MODULE__, {:play, List.wrap(note_or_notes), release})
  end

  @spec halt(Note.t() | [Note.t()] | :all) :: :ok
  def halt(note_or_notes \\ :all)

  def halt(:all) do
    GenServer.cast(__MODULE__, {:halt, 0..127})
  end

  def halt(note_or_notes) do
    GenServer.cast(__MODULE__, {:halt, List.wrap(note_or_notes)})
  end
end
