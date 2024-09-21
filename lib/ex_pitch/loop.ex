defmodule ExPitch.Loop do
  use GenServer

  use ExPitch

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
    case hit(seq) do
      nil ->
        nil

      drum ->
        drum
        |> drum()
        |> play()
    end

    {:noreply, state}
  end

  def hit(seq) do
    cond do
      rem(seq, 48) == 0 -> :clap
      rem(seq, 24) == 0 -> :kick
      rem(seq, 6) == 0 -> :hat_closed
      true -> nil
    end
  end

  def chords do
    [
      chord(:D),
      chord(:Fs, :minor),
      chord(:Fs),
      chord(:B, :minor)
    ]
  end
end
