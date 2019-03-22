defmodule Siano.TransactionsTest do
  use Siano.DataCase
  import Siano.Factory

  alias Siano.Transactions

  describe "transactions" do
    alias Siano.Transactions.Transaction

    @valid_attrs %{amount: "120.5", date: "2010-04-17T14:00:00Z"}
    @update_attrs %{amount: "456.7", date: "2011-05-18T15:01:01Z"}
    @invalid_attrs %{amount: nil, date: nil}

    test "list_transactions/0 returns all transactions" do
      transaction = insert(:transaction) |> Unpreloader.forget(:budget)
      assert Transactions.list_transactions(transaction.budget_id) == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = insert(:transaction) |> Unpreloader.forget(:budget)
      assert Transactions.get_transaction!(transaction.id, transaction.budget_id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      budget = insert(:budget)
      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(@valid_attrs, budget.id)
      assert transaction.amount == Decimal.new("120.5")
      assert transaction.date == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = insert(:transaction) |> Unpreloader.forget(:budget)
      assert {:ok, %Transaction{} = transaction} = Transactions.update_transaction(transaction, @update_attrs)
      assert transaction.amount == Decimal.new("456.7")
      assert transaction.date == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = insert(:transaction) |> Unpreloader.forget(:budget)
      assert {:error, %Ecto.Changeset{}} = Transactions.update_transaction(transaction, @invalid_attrs)
      assert transaction == Transactions.get_transaction!(transaction.id, transaction.budget_id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = insert(:transaction) |> Unpreloader.forget(:budget)
      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transaction!(transaction.id, transaction.budget_id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = insert(:transaction)
      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end
  end
end
