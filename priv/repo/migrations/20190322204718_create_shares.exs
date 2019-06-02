defmodule Siano.Repo.Migrations.CreateShares do
  use Ecto.Migration

  def change do
    create table(:shares) do
      add :amount, :decimal, null: false
      add :transaction_id, references(:transactions, on_delete: :delete_all), null: false
      add :member_id, references(:budget_members, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:shares, [:transaction_id])
    create index(:shares, [:member_id])
  end
end
