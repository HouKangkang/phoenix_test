defmodule HelloPhoenix.Repo.Migrations.CreateUserTopicMsg do
  use Ecto.Migration

  def change do
    create table(:user_topic_msg) do
      add :user_id, :integer
      add :topic, :string
      add :latest_msg_id, :integer

      timestamps()
    end

  end
end
