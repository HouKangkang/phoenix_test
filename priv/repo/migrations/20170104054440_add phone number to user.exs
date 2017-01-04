defmodule :"Elixir.HelloPhoenix.Repo.Migrations.Add phone number to user" do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :phone_number, :string
    end
  end
end
