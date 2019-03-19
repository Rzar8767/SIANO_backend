defmodule Siano.Transfer.Budget do
  use Ecto.Schema
  import Ecto.Changeset

  schema "budgets" do
    field :color, :string
    field :name, :string
    field :owner_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(budget, attrs) do
    budget
    |> cast(attrs, [:name, :color])
    |> validate_required([:name, :color, :owner_id])
  end
end
