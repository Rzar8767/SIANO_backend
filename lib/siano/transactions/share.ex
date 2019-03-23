defmodule Siano.Transactions.Share do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shares" do
    field :amount, :decimal

    belongs_to :transaction, Siano.Transactions.Transaction
    belongs_to :member, Siano.Transfer.Member

    timestamps(type: :utc_datetime)
  end

  #TODO: Add check for if member_id belongs to the same budget as transaction
  @doc false
  def changeset(share, attrs) do
    share
    |> cast(attrs, [:amount, :transaction_id, :member_id])
    |> foreign_key_constraint(:transaction_id)
    |> foreign_key_constraint(:member_id)
    |> validate_required([:amount])
  end
end

