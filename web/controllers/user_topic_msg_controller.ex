defmodule HelloPhoenix.UserTopicMsgController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.UserTopicMsg

#  def index(conn, _params) do
#    user_topic_msg = Repo.all(UserTopicMsg)
#    render(conn, "index.json", user_topic_msg: user_topic_msg)
#  end
#
#  def create(conn, %{"user_topic_msg" => user_topic_msg_params}) do
#    changeset = UserTopicMsg.changeset(%UserTopicMsg{}, user_topic_msg_params)
#
#    case Repo.insert(changeset) do
#      {:ok, user_topic_msg} ->
#        conn
#        |> put_status(:created)
#        |> put_resp_header("location", user_topic_msg_path(conn, :show, user_topic_msg))
#        |> render("show.json", user_topic_msg: user_topic_msg)
#      {:error, changeset} ->
#        conn
#        |> put_status(:unprocessable_entity)
#        |> render(HelloPhoenix.ChangesetView, "error.json", changeset: changeset)
#    end
#  end
#
#  def show(conn, %{"id" => id}) do
#    user_topic_msg = Repo.get!(UserTopicMsg, id)
#    render(conn, "show.json", user_topic_msg: user_topic_msg)
#  end
#
#  def update(conn, %{"id" => id, "user_topic_msg" => user_topic_msg_params}) do
#    user_topic_msg = Repo.get!(UserTopicMsg, id)
#    changeset = UserTopicMsg.changeset(user_topic_msg, user_topic_msg_params)
#
#    case Repo.update(changeset) do
#      {:ok, user_topic_msg} ->
#        render(conn, "show.json", user_topic_msg: user_topic_msg)
#      {:error, changeset} ->
#        conn
#        |> put_status(:unprocessable_entity)
#        |> render(HelloPhoenix.ChangesetView, "error.json", changeset: changeset)
#    end
#  end
#
#  def delete(conn, %{"id" => id}) do
#    user_topic_msg = Repo.get!(UserTopicMsg, id)
#
#    # Here we use delete! (with a bang) because we expect
#    # it to always work (and if it does not, it will raise).
#    Repo.delete!(user_topic_msg)
#
#    send_resp(conn, :no_content, "")
#  end
end
