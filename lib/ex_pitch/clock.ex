defmodule ExPitch.Clock do
  @type source :: {:midi, %Midiex.MidiPort{}} | {:elixir, pos_integer()}

  @spec child_spec(source) :: map()
  def child_spec({:midi, port}) do
    ExPitch.Clock.MIDI.child_spec(port)
  end

  def child_spec({:genserver, bpm}) do
    ExPitch.Clock.GenServer.child_spec(bpm)
  end
end
