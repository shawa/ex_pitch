defmodule ExPitch.Clock do
  use GenServer

  alias ExPitch.PubSub

  require Logger

  @midi_timing_clock 248
  @midi_start 250
  @midi_stop 252

  @enforce_keys [:clock_port, :sequence_number]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{
          clock_port: %Midiex.MidiPort{},
          sequence_number: non_neg_integer()
        }

  @impl GenServer
  def init(clock_port) do
    state = %__MODULE__{
      clock_port: clock_port,
      sequence_number: 0
    }

    {:ok, state, {:continue, :subscribe_clock}}
  end

  @impl GenServer
  def handle_continue(:subscribe_clock, state) do
    PubSub.subscribe({:midi, "IAC Driver Clock"})
    {:noreply, state}
  end

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl GenServer
  def handle_info(%{data: [@midi_timing_clock]}, state) do
    new_sequence_number = state.sequence_number + 1
    PubSub.broadcast(:clock, new_sequence_number)
    {:noreply, %__MODULE__{state | sequence_number: new_sequence_number}}
  end

  def handle_info(%{data: [@midi_start]}, state) do
    {:noreply, %__MODULE__{state | sequence_number: 0}}
  end

  def handle_info(%{data: [@midi_stop]}, state) do
    {:noreply, state}
  end

  @impl GenServer

  def handle_cast(:reset, state) do
    {:noreply, %__MODULE__{state | sequence_number: 0}}
  end

  @spec reset() :: :ok
  def reset() do
    GenServer.cast(__MODULE__, :reset)
  end
end
