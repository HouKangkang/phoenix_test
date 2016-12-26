defmodule HelloPhoenix.CommonChannel do
  @moduledoc false

  use Phoenix.Channel

  def join("users_socket:" <> user_id, _message, socket) do
#   query all topics subscribed by userId
    topics = ["haha:haha", "haha:heihei"]

    {:ok, socket
         |> assign(:topics, [])
         |> put_new_topics(topics)}
  end

#  def handle_in("watch", %{"topic" => topic} = params, socket) do
#    IO.puts("watch, param: #{inspect params}, topic: #{topic}")
#    {:reply, :ok, put_new_topics(socket, [topic])}
#  end
#
#  def handle_in("unwatch", %{"topic" => topic} = params, socket) do
#    {:reply, :ok, MyApp.Endpoint.unsubscribe(topic)}
#  end

  defp put_new_topics(socket, topics) do
    IO.puts("sub to topics: #{inspect topics}")
    Enum.reduce(topics, socket, fn topic, acc ->
      topics = acc.assigns.topics
      if topic in topics do
        acc
      else
#        :ok = HelloPhoenix.Endpoint.subscribe(topic)
        :ok = Phoenix.PubSub.subscribe HelloPhoenix.PubSub, self(), topic
#        Phoenix.PubSub.subscribe(socket.pubsub_server, socket.topic,
#            link: true,
#            fastlane: {socket.transport_pid,
#                       socket.serializer,
#                       socket.channel.__intercepts__()})

        assign(acc, :topics, [topic | topics])
      end
    end)
  end

  alias Phoenix.Socket.Broadcast
  def handle_info(%Broadcast{topic: topic, event: ev, payload: payload}, socket) do
    push socket, ev, Map.put(payload, "topic", topic)
    {:noreply, socket}
  end

  intercept(["invited", "new_msg"])

  def handle_out("invited", payload, socket) do
    push socket, "invited", payload
    {:noreply, socket}
  end

  def handle_out("new_msg", payload, socket) do
    push socket, "new_msg", payload
    {:noreply, socket}
  end


end
