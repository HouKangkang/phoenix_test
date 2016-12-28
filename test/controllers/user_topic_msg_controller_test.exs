defmodule HelloPhoenix.UserTopicMsgControllerTest do
  use HelloPhoenix.ConnCase

  alias HelloPhoenix.UserTopicMsg
  @valid_attrs %{latest_msg_id: 42, topic: "some content", user_id: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_topic_msg_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    user_topic_msg = Repo.insert! %UserTopicMsg{}
    conn = get conn, user_topic_msg_path(conn, :show, user_topic_msg)
    assert json_response(conn, 200)["data"] == %{"id" => user_topic_msg.id,
      "user_id" => user_topic_msg.user_id,
      "topic" => user_topic_msg.topic,
      "latest_msg_id" => user_topic_msg.latest_msg_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_topic_msg_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_topic_msg_path(conn, :create), user_topic_msg: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(UserTopicMsg, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_topic_msg_path(conn, :create), user_topic_msg: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user_topic_msg = Repo.insert! %UserTopicMsg{}
    conn = put conn, user_topic_msg_path(conn, :update, user_topic_msg), user_topic_msg: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(UserTopicMsg, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user_topic_msg = Repo.insert! %UserTopicMsg{}
    conn = put conn, user_topic_msg_path(conn, :update, user_topic_msg), user_topic_msg: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    user_topic_msg = Repo.insert! %UserTopicMsg{}
    conn = delete conn, user_topic_msg_path(conn, :delete, user_topic_msg)
    assert response(conn, 204)
    refute Repo.get(UserTopicMsg, user_topic_msg.id)
  end
end
