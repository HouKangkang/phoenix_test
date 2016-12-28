defmodule HelloPhoenix.Message do
  use HelloPhoenix.Web, :model
  alias HelloPhoenix.Message
  alias HelloPhoenix.UserTopicMsg


  schema "messages" do
    field :topic, :string
    field :from_user_id, :integer
    field :content, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:topic, :from_user_id, :content])
    |> validate_required([:topic, :from_user_id, :content])
  end

  def to_dict(msg) do
    %{
      "id": msg.id,
      "topic": msg.topic,
      "from": msg.from_user_id,
      "body": msg.content,
      "createdAt": msg.inserted_at,
      "updatedAt": msg.updated_at
    }
  end

  def create(msg_params) do
    changeset = Message.changeset(%Message{}, msg_params)
    Repo.insert(changeset)
#
#    case Repo.insert(changeset) do
#      {:ok, message} ->
#        message
#      {:error, changeset} ->
#        changeset
#    end
  end

  def query_by_user_topic(user_id, topic) do

    latest_msg_id = UserTopicMsg.query_by_user_topic(user_id, topic)

    Repo.all(from m in Message, where: m.topic == ^topic and m.id > ^latest_msg_id, select: m)
  end


end
