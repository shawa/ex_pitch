defmodule ExPitch.PubSub do
  def child_spec(_) do
    Phoenix.PubSub.child_spec(name: __MODULE__)
  end

  @type topic :: {:midi, String.t()} | :clock
  @spec subscribe(topic()) :: :ok | {:error, term()}
  def subscribe(topic) do
    Phoenix.PubSub.subscribe(__MODULE__, serialize_topic(topic))
  end

  @spec unsubscribe(topic()) :: :ok
  def unsubscribe(topic) do
    Phoenix.PubSub.unsubscribe(__MODULE__, serialize_topic(topic))
  end

  @spec broadcast(topic(), Phoenix.PubSub.message()) :: :ok | {:error, term()}
  def broadcast(topic, message) do
    Phoenix.PubSub.broadcast(__MODULE__, serialize_topic(topic), message)
  end

  defp serialize_topic(topic) do
    :erlang.term_to_binary(topic)
  end
end
