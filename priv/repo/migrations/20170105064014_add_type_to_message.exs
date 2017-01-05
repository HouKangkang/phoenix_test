defmodule HelloPhoenix.Repo.Migrations.AddTypeToMessage do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :type, :string
    end
  end
end
