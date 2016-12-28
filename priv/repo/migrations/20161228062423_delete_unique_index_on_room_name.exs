defmodule HelloPhoenix.Repo.Migrations.DeleteUniqueIndexOnRoomName do
  use Ecto.Migration

  def change do
    drop index(:rooms, [:name])
  end

end
