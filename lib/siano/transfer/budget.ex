defmodule Siano.Transfer.Budget do
  use Ecto.Schema
  import Ecto.Changeset

  schema "budgets" do
    field :color, :string
    field :name, :string

    belongs_to :owner, Siano.Accounts.User
    has_many :members, Siano.Transfer.Budget

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(budget, attrs) do
    budget
    |> cast(attrs, [:name, :color, :owner_id])
    |> foreign_key_constraint(:owner_id)
    |> validate_required([:name])
  end
end