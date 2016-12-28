defmodule HelloPhoenix.RoomController do
  use HelloPhoenix.Web, :controller
  use HelloPhoenix.Web, :common

  alias HelloPhoenix.Room
  alias HelloPhoenix.UserRoom

  def index(conn, _params) do
    rooms = Repo.all(Room)
    render(conn, "index.json", rooms: rooms)
  end

  def create(conn, %{"room" => room_params}) do
#   need transaction here
    user_ids = room_params["userIds"]
    result = with {:ok, room} <- Room.create(room_params),
                  {:ok, room, user_ids} <- UserRoom.create(room, user_ids),
            do: {:ok, room}

    case result do
      {:ok, :exist, room} ->
          for user_id <- user_ids do
             IO.puts("send invite msg to user: #{user_id}")
             Phoenix.Channel.Server.broadcast(
                   HelloPhoenix.PubSub,
                   "users_socket:#{user_id}",
                   "invited",
                   %{"body": "body", "topic": "#{room.topic}"}
             )
          end
         conn |> api_suc(201, %{"topicId": room.topic, "roomName": room.name, "roomId": room.id, "useIds": user_ids})
      {:ok, room} ->
          for user_id <- user_ids do
             IO.puts("send invite msg to user: #{user_id}")
             Phoenix.Channel.Server.broadcast(
                   HelloPhoenix.PubSub,
                   "users_socket:#{user_id}",
                   "invited",
                   %{"body": "body", "topic": "#{room.topic}"}
             )
          end
         conn |> api_suc(201, %{"topicId": room.topic, "roomName": room.name, "roomId": room.id, "useIds": user_ids})
      {:error, msg} -> conn |> api_err(400, msg)
    end

  end

#  def show(conn, %{"id" => id}) do
#    room = Repo.get!(Room, id)
#    render(conn, "show.json", room: room)
#  end
#
#  def update(conn, %{"id" => id, "room" => room_params}) do
#    room = Repo.get!(Room, id)
#    changeset = Room.changeset(room, room_params)
#
#    case Repo.update(changeset) do
#      {:ok, room} ->
#        render(conn, "show.json", room: room)
#      {:error, changeset} ->
#        conn
#        |> put_status(:unprocessable_entity)
#        |> render(HelloPhoenix.ChangesetView, "error.json", changeset: changeset)
#    end
#  end
#
#  def delete(conn, %{"id" => id}) do
#    room = Repo.get!(Room, id)
#
#    # Here we use delete! (with a bang) because we expect
#    # it to always work (and if it does not, it will raise).
#    Repo.delete!(room)
#
#    send_resp(conn, :no_content, "")
#  end
end
