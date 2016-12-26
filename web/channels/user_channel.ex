defmodule HelloPhoenix.UserChannel do
  use Phoenix.Channel

  def join("users:" <> user_id, _message, socket) do
    {:ok, socket}
  end
#
#
#  def join("room:" <> _private_room_id, _params, _socket) do
#    {:error, %{reason: "unauthorized"}}
#  end


#  def handle_in("new_msg", %{"body" => body}, socket) do
#      broadcast! socket, "new_msg", %{body: body}
#      {:noreply, socket}
#  end

  intercept(["invited"])

  def handle_out("invited", payload, socket) do
    push socket, "invited", payload
    {:noreply, socket}
  end

end