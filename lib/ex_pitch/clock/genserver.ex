defmodule ExPitch.Clock.GenServer do
  use GenServer

  @ticks_per_beat 24

  alias ExPitch.PubSub.Clock

  @enforce_keys ~w[bpm timer_ref anchor_time total_ticks]a
  defstruct @enforce_keys

  @type t :: %__MODULE__{
          bpm: pos_integer(),
          timer_ref: reference(),
          anchor_time: integer(),
          total_ticks: integer()
        }

  def init(bpm) do
    {:ok,
     %__MODULE__{
       bpm: bpm,
       timer_ref: make_ref(),
       anchor_time: System.monotonic_time(:millisecond),
       total_ticks: 0
     }, {:continue, :enter_loop}}
  end

  def start_link(bpm) do
    IO.inspect("STARTING")
    GenServer.start_link(__MODULE__, bpm, name: __MODULE__)
  end

  def handle_continue(:enter_loop, state) do
    Clock.broadcast(:start)
    send(self(), :tick)

    {:noreply, state}
  end

  defp next_tick_time(anchor_time, bpm, ticks) do
    interval = 60_000 / (bpm * @ticks_per_beat)
    trunc(anchor_time + interval * ticks)
  end

  def handle_info(:tick, state) do
    Clock.broadcast(:tick)

    next_tick_time =
      next_tick_time(state.anchor_time, state.bpm, state.total_ticks)

    timer_ref =
      Process.send_after(self(), :tick, next_tick_time, abs: true)

    {:noreply,
     %{
       state
       | timer_ref: timer_ref,
         total_ticks: state.total_ticks + 1
     }}
  end

  def handle_cast(:stop, state) do
    Process.cancel_timer(state.timer_ref)
    {:noreply, state}
  end

  def handle_cast(:start, state) do
    {:continue, state, :enter_loop}
  end

  def start() do
    GenServer.cast(__MODULE__, :start)
  end

  def stop() do
    GenServer.cast(__MODULE__, :stop)
  end
end
