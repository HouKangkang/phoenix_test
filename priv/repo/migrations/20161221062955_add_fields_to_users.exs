defmodule HelloPhoenix.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :password, :string
    end
  end
end
