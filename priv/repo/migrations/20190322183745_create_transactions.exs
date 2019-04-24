defmodule Siano.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :title, :text, null: false
      add :date, :utc_datetime, null: false, default: fragment("now()")
      add :category_id, references(:categories, on_delete: :nilify_all)
      add :budget_id, references(:budgets, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:transactions, [:budget_id])
    create index(:transactions, [:category_id])
  end
end
