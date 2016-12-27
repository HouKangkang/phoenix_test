defmodule HelloPhoenix.Room do
  use HelloPhoenix.Web, :model

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
      "topic" => room.topic
    }
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
    changeset = changeset(%HelloPhoenix.Room{}, room_params)
    IO.puts("changeset of room: #{inspect changeset}")

    result = Repo.insert(changeset)
    IO.puts("insert result: #{inspect result}")

    result
#    case result do
#      {:ok, room} -> room
#      {:error, changeset} -> changeset
#    end
  end
end
