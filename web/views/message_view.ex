defmodule HelloPhoenix.MessageView do
  use HelloPhoenix.Web, :view

  def render("index.json", %{messages: messages}) do
    %{data: render_many(messages, HelloPhoenix.MessageView, "message.json")}
  end

  def render("show.json", %{message: message}) do
    %{data: render_one(message, HelloPhoenix.MessageView, "message.json")}
  end

  def render("message.json", %{message: message}) do
    %{id: message.id,
      topic: message.topic,
      from_user_id: message.from_user_id,
      content: message.content}
  end
end
