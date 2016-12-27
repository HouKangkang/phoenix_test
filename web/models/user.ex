defmodule HelloPhoenix.User do
  use HelloPhoenix.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :bio, :string
    field :number_of_pets, :integer
    field :password, :string
    field :salt, :string

#    many_to_many :rooms, HelloPhoenix.Room, join_through: "user_rooms"

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :password, :salt])
    |> validate_format(:email, ~r/@/)
    |> validate_required([:name, :email, :password, :salt])
  end

  def to_dict(user) do
    %{
      "userId" => user.id,
      "username" => user.name,
      "email" => user.email,
      "createdAt" => user.inserted_at,
      "updatedAt" => user.updated_at
    }
  end

end
