defmodule Siano.Transfer.Budget do
  use Ecto.Schema
  import Ecto.Changeset

  schema "budgets" do
    field :color, :string
    field :name, :string

    belongs_to :owner, Siano.Accounts.User
    has_many :members, Siano.Transfer.Member

    timestamps(type: :utc_datetime)
  end

  def update_changeset(budget, attrs) do
    budget
    |> valid_user(attrs)
    |> changeset(attrs)
  end

  @doc false
  def changeset(budget, attrs) do
    budget
    |> cast(attrs, [:name, :color, :owner_id])
    |> validate_required([:name])
    |> foreign_key_constraint(:owner_id)
  end

  def valid_user(budget, %{"owner_id" => owner_id} =  attrs) do
    owner_exists = Siano.Transfer.budget_exists?(%{"id" => budget.id, "owner_id" => owner_id})
    member_exists = Siano.Transfer.member_exists?(%{"budget_id" => budget.id, "user_id" => owner_id})
    if owner_exists || member_exists do
      changeset(budget, attrs)
    else
      budget
      |> change
      |> add_error(:owner_id, "person with owner_id not in budget")
      |> changeset(attrs)
    end
  end

  def valid_user(budget, attrs) do
    changeset(budget, attrs)
  end
end
