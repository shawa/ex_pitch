defmodule ExPitch.PubSub.MIDI do
  def child_spec(_) do
    Supervisor.child_spec({Phoenix.PubSub, name: __MODULE__}, id: __MODULE__)
  end

  @type topic :: String.t()
  @spec subscribe(topic()) :: :ok | {:error, term()}
  def subscribe(topic) do
    Phoenix.PubSub.subscribe(__MODULE__, topic)
  end

  @spec unsubscribe(topic()) :: :ok
  def unsubscribe(topic) do
    Phoenix.PubSub.unsubscribe(__MODULE__, topic)
  end

  @spec broadcast(topic(), Phoenix.PubSub.message()) :: :ok | {:error, term()}
  def broadcast(topic, message) do
    Phoenix.PubSub.broadcast(__MODULE__, topic, message)
  end
end
