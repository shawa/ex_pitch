defmodule ExPitch do
  defmacro __using__(_opts) do
    quote do
      import ExPitch.Note
      import ExPitch.Chord
      import ExPitch.Producer
    end
  end

  @spec port_by_name(String.t(), :input | :output) :: %Midiex.MidiPort{}
  def port_by_name(str, mode \\ :input) do
    ports = Midiex.ports(mode)

    %Midiex.MidiPort{} = Enum.find(ports, &match?(%{name: ^str}, &1))
  end

  def port_names() do
    Midiex.ports()
    |> Enum.map(&{&1.direction, &1.name})
  end
end
