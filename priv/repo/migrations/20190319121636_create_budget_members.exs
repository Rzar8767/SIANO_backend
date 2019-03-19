defmodule Siano.Repo.Migrations.CreateBudgetMembers do
  use Ecto.Migration

  def change do
    create table(:budget_members) do
      add :nickname, :string, null: false
      add :user_id, references(:users, on_delete: :nothing)
      add :budget_id, references(:budgets, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:budget_members, [:user_id])
    create index(:budget_members, [:budget_id])
  end
end
