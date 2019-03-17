defmodule Siano.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false
      add :password_hash, :string
      add :email, :string, null: false
      add :is_active, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:username])
    create unique_index(:users, [:email])
  end
end
