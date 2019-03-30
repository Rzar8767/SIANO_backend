defmodule Siano.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :title, :string
    field :date, :utc_datetime

    belongs_to :budget, Siano.Transfer.Budget
    belongs_to :category, Siano.Transactions.Category
    has_many :shares, Siano.Transactions.Share

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:title, :date, :category_id])
    |> validate_required([:title])
    |> foreign_key_constraint(:budget_id)
  end
end
