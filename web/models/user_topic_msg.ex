defmodule HelloPhoenix.UserTopicMsg do
  use HelloPhoenix.Web, :model
  alias HelloPhoenix.UserTopicMsg

  schema "user_topic_msg" do
    field :user_id, :integer
    field :topic, :string
    field :latest_msg_id, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :topic, :latest_msg_id])
    |> validate_required([:user_id, :topic, :latest_msg_id])
  end

  def query_by_user_topic(user_id, topic) do
    record = Repo.one((from item in UserTopicMsg, where: item.user_id == type(^user_id, :integer) and item.topic == ^topic, limit: 1))

    if record do
      record.latest_msg_id
    else
      0
    end

  end

end
