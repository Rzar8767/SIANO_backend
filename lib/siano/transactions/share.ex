defmodule Siano.Transactions.Share do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "shares" do
    field :amount, :decimal

    belongs_to :transaction, Siano.Transactions.Transaction
    belongs_to :member, Siano.Transfer.Member

    timestamps(type: :utc_datetime)
  end

  def changeset(share, %{"member_id" => member_id} = attrs, budget_id) do
    query = from m in Siano.Transfer.Member,
              where: m.id == ^member_id,
              where: m.budget_id == ^budget_id,
              select: m.id
    unless Siano.Repo.exists?(query) do
      share
      |> change
      |> add_error(:member_id, "member not in budget")
      |> changeset(attrs)
    else
      changeset(share, attrs)
    end
  end

  def changeset(share, attrs, _budget_id) do
    changeset(share, attrs)
  end

  @doc false
  def changeset(share, attrs) do
    share
    #TODO: Disallow change of transaction_id and member_id without validation in update
    |> cast(attrs, [:amount, :transaction_id, :member_id])
    |> validate_required([:amount])
    |> foreign_key_constraint(:transaction_id)
    |> foreign_key_constraint(:member_id)
  end
end

