defmodule HelloPhoenix.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :topic, :string
      add :from_user_id, :integer
      add :content, :string

      timestamps()
    end

  end
end
