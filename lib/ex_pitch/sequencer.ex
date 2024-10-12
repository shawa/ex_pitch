defmodule ExPitch.Sequencer do
  use GenServer
  require Logger

  @type t() :: %{
          ticks: pos_integer(),
          counter: non_neg_integer()
        }

  def init(steps) do
    ticks = steps * 24

    {:ok,
     %{
       ticks: ticks,
       counter: 0,
       sequence_fun: compile_sequence(sequence(), ticks)
     }, {:continue, :subscribe_clock}}
  end

  def handle_continue(:subscribe_clock, state) do
    ExPitch.PubSub.Clock.subscribe()
    {:noreply, state}
  end

  def start_link(steps) do
    GenServer.start_link(__MODULE__, steps, name: __MODULE__)
  end

  def handle_info(:tick, state) do
    notes = state.sequence_fun.(state.counter)

    if notes != [] do
      ExPitch.MIDI.Producer.play(notes)
    end

    {:noreply, %{state | counter: rem(state.counter + 1, state.ticks)}}
  end

  def handle_info(:start, state) do
    {:noreply,
     %{
       state
       | counter: 0
     }}
  end

  def sequence do
    [
      {:C4, {24, 1}},
      {:Ds4, {24, 1}},
      {:F4, 12}
    ]
  end

  def unfold_sequence(sequence, ticks) do
    for tick <- 0..ticks, into: %{} do
      samples =
        sequence
        |> Enum.filter(fn
          {_sample, {multiple, offset}} ->
            rem(tick, multiple) == offset

          {_sample, multiple} ->
            rem(tick, multiple) == 0
        end)
        |> Enum.map(&elem(&1, 0))

      {tick, samples}
    end
  end

  def compile_sequence(sequence, ticks) do
    map = unfold_sequence(sequence, ticks)

    fn tick ->
      Map.fetch!(map, tick)
    end
  end
end
