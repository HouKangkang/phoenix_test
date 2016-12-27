defmodule HelloPhoenix.CommonChannel do
  @moduledoc false

  use Phoenix.Channel
  alias HelloPhoenix.UserRoom

  def join("users_socket:" <> user_id, _message, socket) do
#   subscribe to all his topics when user try to create a socket
#   query all topics subscribed by userId
    topics = UserRoom.query_topics_for_user(String.to_integer(user_id))

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
    Phoenix.Channel.Server.broadcast(
        HelloPhoenix.PubSub,
        "#{topic}",
        "new_msg",
        params
    )
    {:noreply, socket}
#    broadcast socket, "new_msg", %{uid: uid, body: body}
#    {:reply, :ok, MyApp.Endpoint.unsubscribe(topic)}
  end

  alias Phoenix.Socket.Broadcast
  def handle_info(%Broadcast{topic: topic, event: ev, payload: payload}, socket) do
    push socket, ev, Map.put(payload, "topic", topic)
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
