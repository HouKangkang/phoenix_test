defmodule HelloPhoenix.UserTopicMsgController do
  use HelloPhoenix.Web, :controller
  use HelloPhoenix.Web, :common

  alias HelloPhoenix.UserTopicMsg
  alias HelloPhoenix.Message

#  def index(conn, _params) do
#    user_topic_msg = Repo.all(UserTopicMsg)
#    render(conn, "index.json", user_topic_msg: user_topic_msg)
#  end
#
  def save(conn, %{"userId" => user_id, "topic" => topic, "msgId" => msg_id} = _params) do

#   这里需要校验.. 参数中的 msgId 不能比数据库中的 msgId 小

    result =
      case UserTopicMsg.query_by_user_topic(user_id, topic) do
        nil  -> %UserTopicMsg{topic: topic, latest_msg_id: msg_id}
        record -> record
      end
      |> UserTopicMsg.changeset(%{"user_id": user_id, "topic": topic, "latest_msg_id": msg_id})
      |> Repo.insert_or_update


    case result do
      {:ok, user_topic_msg} ->
        api_suc(conn, 200, :ok)
      {:error, changeset} ->
        api_err(conn, 400, changeset)
    end
  end
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
