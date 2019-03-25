defmodule Siano.Repo.Migrations.TransactionsAddTitleDelAmount do
  use Ecto.Migration

  def change do
    alter table("transactions") do
      add :title, :text, null: false
      remove :amount
    end
  end
end
