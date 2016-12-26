defmodule HelloPhoenix.RoomTest do
  use HelloPhoenix.ModelCase

  alias HelloPhoenix.Room

  @valid_attrs %{name: "some content", topic: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Room.changeset(%Room{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Room.changeset(%Room{}, @invalid_attrs)
    refute changeset.valid?
  end
end
