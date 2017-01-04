defmodule HelloPhoenix.User do
  use HelloPhoenix.Web, :model

  alias HelloPhoenix.User

  schema "users" do
    field :name, :string
    field :email, :string
    field :bio, :string
    field :number_of_pets, :integer
    field :password, :string
    field :salt, :string
    field :phone_number, :string

#    many_to_many :rooms, HelloPhoenix.Room, join_through: "user_rooms"

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:phone_number])
#    |> validate_format(:email, ~r/@/)
    |> validate_required([:phone_number])
  end

  def to_dict(user) do
    %{
      "userId" => user.id,
      "username" => user.name,
      "email" => user.email,
      "phoneNumber" => user.phone_number,
      "createdAt" => user.inserted_at,
      "updatedAt" => user.updated_at
    }
  end

  def query_by_phone_number(phone_number) do
    query = from u in User, where: u.phone_number == ^phone_number, select: u, limit: 1
    Repo.one(query)
  end

end
