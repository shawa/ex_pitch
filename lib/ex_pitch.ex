defmodule ExPitch do
  @spec port_by_name(String.t(), :input | :output) :: %Midiex.MidiPort{}
  def port_by_name(str, mode \\ :input) do
    ports = Midiex.ports(mode)

    %Midiex.MidiPort{} = Enum.find(ports, &match?(%{name: ^str}, &1))
  end

  def port_names() do
    Midiex.ports()
    |> Enum.map(&{&1.direction, &1.name})
  end

  defdelegate chord(note), to: ExPitch.Chord
  defdelegate chord(note, character), to: ExPitch.Chord
  defdelegate play(note_or_notes), to: ExPitch.MIDI.Producer
  defdelegate play(note_or_notes, release), to: ExPitch.MIDI.Producer
  defdelegate halt(note_or_notes), to: ExPitch.MIDI.Producer
  defdelegate halt(), to: ExPitch.MIDI.Producer
end
