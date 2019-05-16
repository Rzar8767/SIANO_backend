defmodule Siano.Transfer.Member do
  use Ecto.Schema
  import Ecto.Changeset

  schema "budget_members" do
    field :nickname, :string
    # the user that is "attached" to the budget member
    belongs_to :user, Siano.Accounts.User
    belongs_to :budget, Siano.Transfer.Budget

    has_many :shares, Siano.Transactions.Share, foreign_key: :member_id
    many_to_many :budget_members, Siano.Accounts.User, join_through: "budget_members"

    timestamps(type: :utc_datetime)
  end

  @doc false

  def invitation_changeset(member, attrs) do
    member
    |> cast(attrs, [:nickname])
    |> validate_required([:nickname])
    |> foreign_key_constraint(:budget_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:user_id_and_budget_id_pair, name: :budget_members_user_id_budget_id_index)
    |> unique_constraint(:unique_nickname_in_budget, name: :unique_nickname_in_budget)
  end

  def changeset(member, attrs) do
    member
    |> cast(attrs, [:nickname, :user_id])
    |> validate_required([:nickname])
    |> foreign_key_constraint(:budget_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:user_id_and_budget_id_pair, name: :budget_members_user_id_budget_id_index)
    |> unique_constraint(:unique_nickname_in_budget, name: :unique_nickname_in_budget)
  end
end
