defmodule Siano.TransactionsTest do
  use Siano.DataCase
  import Siano.Factory

  alias Siano.Transactions

  describe "transactions" do
    alias Siano.Transactions.Transaction

    @valid_attrs %{"title" => "some title", "date" => "2010-04-17T14:00:00Z"}
    @update_attrs %{"title" => "some updated title", "date" => "2011-05-18T15:01:01Z"}
    @invalid_attrs %{"title" => nil, "date" => nil}

  def assert_transaction(a, b) do
    assert a.title == b.title
    assert a.date == b.date
    assert a.budget_id == b.budget_id
    assert a.category_id == b.category_id
  end

    test "list_transactions/1 returns all transactions" do
      transaction = insert(:transaction)
      transactions = Transactions.list_transactions(transaction.budget_id)
      assert_transaction(transaction, transactions |> List.first )
    end

    test "get_transaction!/2 returns the transaction with given id" do
      transaction = insert(:transaction)
      assert_transaction(transaction, Transactions.get_transaction!(transaction.id, transaction.budget_id))
    end

    test "create_transaction/2 with valid data creates a transaction" do
      budget = insert(:budget)
      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(@valid_attrs, budget.id)
      assert transaction.title == "some title"
      assert transaction.date == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(@invalid_attrs)
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

  describe "shares" do
    alias Siano.Transactions.Share

    @valid_attrs %{"amount" => 120.5}
    @update_attrs %{"amount" => 456.7}
    @invalid_attrs %{"amount" => nil, "member_id" => -1}

    test "list_shares/2 returns all shares" do
      share = insert(:share) |> Unpreloader.forget(:member)
      assert Transactions.list_shares(share.transaction.budget_id, share.transaction_id) == [share |> Unpreloader.forget(:transaction)]
    end

    test "get_share!/3 returns the share with given id" do
      share = share = insert(:share) |> Unpreloader.forget(:member)
      assert Transactions.get_share!(share.id, share.transaction.budget_id, share.transaction_id) == share |> Unpreloader.forget(:transaction)
    end

    test "create_share/3 with valid data creates a share" do
      share = insert(:share)
      transaction = share.transaction
      assert {:ok, %Share{} = share} = Transactions.create_share(Map.put(@valid_attrs, "member_id", share.member_id), transaction.budget_id, transaction.id)
      assert share.amount == Decimal.new("120.5")
    end

    test "create_share/3 with invalid data returns error changeset" do
      share = insert(:share)
      assert {:error, %Ecto.Changeset{}} = Transactions.create_share(@invalid_attrs, share.transaction.budget_id, share.transaction_id)
    end

    test "create_share/3 with member not in budget returns error changeset" do
      share = insert(:share)
      member = insert(:member)
      attrs = %{"amount" => 14.1, "member_id" => member.id}
      assert {:error, %Ecto.Changeset{}} = Transactions.create_share(attrs, share.transaction.budget_id, share.transaction_id)
    end

    test "update_share/2 with valid data updates the share" do
      share = insert(:share) |> Unpreloader.forget(:member) |> Unpreloader.forget(:transaction)
      assert {:ok, %Share{} = share} = Transactions.update_share(share, @update_attrs)
      assert share.amount == Decimal.new("456.7")
    end

    test "update_share/2 with invalid data returns error changeset" do
      share = insert(:share)
      transaction = share.transaction
      share = share |> Unpreloader.forget(:member) |> Unpreloader.forget(:transaction)
      assert {:error, %Ecto.Changeset{}} = Transactions.update_share(share, @invalid_attrs)
      assert share == Transactions.get_share!(share.id, transaction.budget_id, share.transaction_id)
    end

    test "delete_share/1 deletes the share" do
      share = insert(:share)
      assert {:ok, %Share{}} = Transactions.delete_share(share)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_share!(share.id, share.transaction.budget_id, share.transaction_id) end
    end

    test "change_share/1 returns a share changeset" do
      share = insert(:share)
      assert %Ecto.Changeset{} = Transactions.change_share(share)
    end
  end
end
