defmodule Siano.Repo.Migrations.CreateBudgetMembers do
  use Ecto.Migration

  def change do
    create table(:budget_members) do
      add :nickname, :string, null: false
      add :user_id, references(:users, on_delete: :nilify_all)
      add :budget_id, references(:budgets, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:budget_members, [:user_id])
    create index(:budget_members, [:budget_id])
    create unique_index(:budget_members, [:user_id, :budget_id])
    create unique_index(:budget_members, [:budget_id, :nickname], name: :unique_nickname_in_budget)

  end
end
