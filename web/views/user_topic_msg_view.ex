defmodule HelloPhoenix.UserTopicMsgView do
  use HelloPhoenix.Web, :view

  def render("index.json", %{user_topic_msg: user_topic_msg}) do
    %{data: render_many(user_topic_msg, HelloPhoenix.UserTopicMsgView, "user_topic_msg.json")}
  end

  def render("show.json", %{user_topic_msg: user_topic_msg}) do
    %{data: render_one(user_topic_msg, HelloPhoenix.UserTopicMsgView, "user_topic_msg.json")}
  end

  def render("user_topic_msg.json", %{user_topic_msg: user_topic_msg}) do
    %{id: user_topic_msg.id,
      user_id: user_topic_msg.user_id,
      topic: user_topic_msg.topic,
      latest_msg_id: user_topic_msg.latest_msg_id}
  end
end
