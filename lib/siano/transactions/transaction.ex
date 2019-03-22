defmodule Siano.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :amount, :decimal
    field :date, :utc_datetime

    belongs_to :budget, Siano.Transfer.Budget
    belongs_to :category, Siano.Transactions.Category

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:amount, :date, :category_id])
    |> validate_required([:amount])
  end
end
