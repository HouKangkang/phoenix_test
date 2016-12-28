defmodule HelloPhoenix.MessageTest do
  use HelloPhoenix.ModelCase

  alias HelloPhoenix.Message

  @valid_attrs %{content: "some content", from_user_id: 42, topic: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Message.changeset(%Message{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Message.changeset(%Message{}, @invalid_attrs)
    refute changeset.valid?
  end
end
