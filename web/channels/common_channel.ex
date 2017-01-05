defmodule HelloPhoenix.CommonChannel do
  @moduledoc false

  use Phoenix.Channel
  alias HelloPhoenix.UserRoom
  alias HelloPhoenix.Message

  def join("users_socket:" <> user_id, _message, socket) do
#   subscribe to all his topics when user try to create a socket
#   query all topics subscribed by userId
    topics = UserRoom.query_topics_for_user(String.to_integer(user_id))

#    send self(), {:offline_msgs, topics}

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
        :ok = HelloPhoenix.Endpoint.subscribe(topic)

        assign(acc, :topics, [topic | topics])
      end
    end)
  end

  def handle_in("new_msg", %{"topic" => topic} = params, socket) do
    IO.puts("in common channel: #{inspect params}")

#   persist the message
    {:ok, message} = Message.create(%{"topic": topic, "from_user_id": params["from"], "content": params["body"], "type": params["type"]})

    Phoenix.Channel.Server.broadcast(
        HelloPhoenix.PubSub,
        "#{topic}",
        "new_msg",
        Map.put(params, "id", message.id)
    )
    {:noreply, socket}
#    broadcast socket, "new_msg", %{uid: uid, body: body}
#    {:reply, :ok, MyApp.Endpoint.unsubscribe(topic)}
  end

  def handle_in("get_unread_msgs", %{"topics" => topics} = _params, socket) do
    IO.puts("in query offline msgs, topics: #{inspect topics}")
    user_id = socket.assigns.user_id
  #   push the offline_msgs back
    for topic <- topics do
      offline_msgs = Message.query_by_user_topic(user_id, topic)
      IO.puts("offline messages: #{inspect offline_msgs}")
      if offline_msgs != [] do
        push socket, "offline_msgs", %{"topic": topic, "data": Enum.map(offline_msgs, &(Message.to_dict(&1)))}
      end
    end
    {:noreply, socket}
  end

#  def handle_info(:get_history_msgs, %{"topics" => topic} = params, socket) do
#    IO.puts("in query offline msgs, topics: #{inspect topics}")
#    user_id = socket.assigns.user_id
#  #   push the offline_msgs back
#    for topic <- topics do
#      offline_msgs = Message.query_by_user_topic(user_id, topic)
#      IO.puts("offline messages: #{inspect offline_msgs}")
#      if offline_msgs != [] do
#        push socket, "offline_msgs", %{"data": Enum.map(offline_msgs, &(Message.to_dict(&1)))}
#      end
#    end
#    {:noreply, socket}
#  end

  alias Phoenix.Socket.Broadcast
  def handle_info(%Broadcast{topic: topic, event: ev, payload: payload}, socket) do
#    push socket, ev, Map.put(payload, "topic", topic)
    push socket, ev, payload
    {:noreply, socket}
  end

  intercept(["invited", "new_msg"])

  def handle_out("invited", %{"topic": topic} = payload, socket) do
    IO.puts("triggered, params: #{inspect payload}, topic: #{topic}")
    put_new_topics socket, [topic]
#    push socket, "invited", payload
    {:noreply, socket}
  end

end
