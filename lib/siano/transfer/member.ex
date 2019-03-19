defmodule Siano.Transfer.Member do
  use Ecto.Schema
  import Ecto.Changeset

  schema "budget_members" do
    field :nickname, :string
    field :user_id, :id
    field :budget_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:nickname, :user_id])
    |> foreign_key_constraint(:budget_id)
    |> validate_required([:nickname])
  end
end
