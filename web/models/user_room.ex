defmodule HelloPhoenix.UserRoom do
  use HelloPhoenix.Web, :model

  alias HelloPhoenix.UserRoom
  alias HelloPhoenix.Room

  schema "user_rooms" do
#    belongs_to :user, HelloPhoenix.User
#    belongs_to :room, HelloPhoenix.Room
     field :user_id, :integer
     field :room_id, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :room_id])
    |> validate_required([:user_id, :room_id])
    |> unique_constraint(:user_id_room_id)
  end

  def create(room, user_ids) do
    IO.puts("in user_room insert, #{inspect room}, #{user_ids}")
    now = DateTime.utc_now
    user_rooms = Enum.map(user_ids, &(%{"user_id": &1, "room_id": room.id, "updated_at": now, "inserted_at": now}))
#     to be batch inserted
    result = Repo.insert_all("user_rooms", user_rooms)
    IO.puts("insert result of user_rooms: #{inspect result}")
    {:ok, room, user_ids}
  end

  def query_topics_for_user(user_id) do
    rooms = query_rooms_for_user user_id
    Enum.map(rooms, &(&1.topic))

  end

  def query_rooms_for_user(user_id) do
    query = from item in UserRoom,
        where: item.user_id == ^user_id,
        select: item

    user_rooms = Repo.all(query)
    IO.puts("query user_rooms from DB: #{inspect user_rooms}")

    room_ids = Enum.map(user_rooms, &(&1.room_id))

    query = from r in Room,
        where: r.id in ^room_ids,
        select: r
    rooms = Repo.all(query)
  end

end
