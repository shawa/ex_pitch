defmodule ExPitch.Loop do
  use GenServer
  use ExPitch

  require Logger
  require ExPitch.Sequence

  alias ExPitch.PubSub

  def init(_) do
    {:ok, nil, {:continue, :subscribe_clock}}
  end

  def handle_continue(:subscribe_clock, nil) do
    PubSub.subscribe(:clock)
    {:noreply, nil}
  end

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def handle_info(seq, state) do
    case sequence(seq) do
      [] -> nil
      notes -> hit(notes)
    end

    {:noreply, state}
  end

  def chords do
    [
      chord(:D),
      chord(:Fs, :minor),
      chord(:Fs),
      chord(:B, :minor)
    ]
  end

  ExPitch.Sequence.defsequence foo() do
    1 -> :kick
    3 / 4 -> :hat_closed
  end
end
