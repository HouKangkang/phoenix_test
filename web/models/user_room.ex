defmodule HelloPhoenix.UserRoom do
  use HelloPhoenix.Web, :model

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

end
