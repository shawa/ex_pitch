defmodule ExPitch.PubSub.Clock do
  @topic "ticks"
  require Logger

  @type msg :: :start | :tick | :stop
  def child_spec(_) do
    Supervisor.child_spec({Phoenix.PubSub, name: __MODULE__}, id: __MODULE__)
  end

  @spec subscribe() :: :ok | {:error, term()}
  def subscribe do
    Phoenix.PubSub.subscribe(__MODULE__, @topic)
  end

  @spec unsubscribe() :: :ok
  def unsubscribe do
    Phoenix.PubSub.unsubscribe(__MODULE__, @topic)
  end

  @spec broadcast(msg()) :: :ok | {:error, term()}
  def broadcast(message) do
    # Logger.debug("CLOCK: #{message}")
    Phoenix.PubSub.broadcast(__MODULE__, @topic, message)
  end
end
