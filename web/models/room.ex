defmodule HelloPhoenix.Room do
  use HelloPhoenix.Web, :model
  alias HelloPhoenix.Room

  schema "rooms" do
    field :name, :string
    field :topic, :string

#    many_to_many :users, HelloPhoenix.User, join_through: "user_rooms"

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :topic])
    |> validate_required([:name, :topic])
    |> unique_constraint(:name)
  end


  def to_dict(room) do
    %{
      "roomId" => room.id,
      "roomName" => room.name,
      "topicId" => room.topic
    }
  end

  def query_by_topic(topic) do
    (from r in Room, where: r.topic == ^topic, select: r) |> first |> Repo.one
  end

  def generate_room_topic(user_ids, type) do

#   just a mock generator for room topic
    case type do
      "single" -> {:ok, Enum.join(Enum.sort(user_ids), "+")}
      "group" -> {:ok, HelloPhoenix.Util.StringUtil.generate_random_string(40)}
      _ -> {:error, "unknown type"}
    end

  end

  def create(room_params) do
    type = room_params["type"]
    {:ok, topic} = topic = generate_room_topic room_params["userIds"], room_params["type"]

    db_room = query_by_topic topic
    if type == "single" and db_room do
      {:ok, :exist, db_room}
    else
      changeset = changeset(%HelloPhoenix.Room{}, Map.put(room_params, "topic", topic))
      IO.puts("changeset of room: #{inspect changeset}")

      result = Repo.insert(changeset)
      IO.puts("insert result: #{inspect result}")

      result
    end
  end
end
