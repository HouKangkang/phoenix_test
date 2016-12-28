defmodule HelloPhoenix.UserTopicMsgTest do
  use HelloPhoenix.ModelCase

  alias HelloPhoenix.UserTopicMsg

  @valid_attrs %{latest_msg_id: 42, topic: "some content", user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserTopicMsg.changeset(%UserTopicMsg{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserTopicMsg.changeset(%UserTopicMsg{}, @invalid_attrs)
    refute changeset.valid?
  end
end
