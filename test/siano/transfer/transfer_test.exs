defmodule Siano.TransferTest do
  use Siano.DataCase

  alias Siano.Transfer

  describe "budgets" do
    alias Siano.Transfer.Budget

    @valid_attrs %{color: "some color", name: "some name"}
    @update_attrs %{color: "some updated color", name: "some updated name"}
    @invalid_attrs %{color: nil, name: nil}

    def budget_fixture(attrs \\ %{}) do
      {:ok, budget} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transfer.create_budget()

      budget
    end

    test "list_budgets/0 returns all budgets" do
      budget = budget_fixture()
      assert Transfer.list_budgets() == [budget]
    end

    test "get_budget!/1 returns the budget with given id" do
      budget = budget_fixture()
      assert Transfer.get_budget!(budget.id) == budget
    end

    test "create_budget/1 with valid data creates a budget" do
      assert {:ok, %Budget{} = budget} = Transfer.create_budget(@valid_attrs)
      assert budget.color == "some color"
      assert budget.name == "some name"
    end

    test "create_budget/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transfer.create_budget(@invalid_attrs)
    end

    test "update_budget/2 with valid data updates the budget" do
      budget = budget_fixture()
      assert {:ok, %Budget{} = budget} = Transfer.update_budget(budget, @update_attrs)
      assert budget.color == "some updated color"
      assert budget.name == "some updated name"
    end

    test "update_budget/2 with invalid data returns error changeset" do
      budget = budget_fixture()
      assert {:error, %Ecto.Changeset{}} = Transfer.update_budget(budget, @invalid_attrs)
      assert budget == Transfer.get_budget!(budget.id)
    end

    test "delete_budget/1 deletes the budget" do
      budget = budget_fixture()
      assert {:ok, %Budget{}} = Transfer.delete_budget(budget)
      assert_raise Ecto.NoResultsError, fn -> Transfer.get_budget!(budget.id) end
    end

    test "change_budget/1 returns a budget changeset" do
      budget = budget_fixture()
      assert %Ecto.Changeset{} = Transfer.change_budget(budget)
    end
  end

  describe "budget_members" do
    alias Siano.Transfer.Member

    @valid_attrs %{nickname: "some nickname"}
    @update_attrs %{nickname: "some updated nickname"}
    @invalid_attrs %{nickname: nil}

    def member_fixture(attrs \\ %{}) do
      {:ok, member} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transfer.create_member()

      member
    end

    test "list_budget_members/0 returns all budget_members" do
      member = member_fixture()
      assert Transfer.list_budget_members() == [member]
    end

    test "get_member!/1 returns the member with given id" do
      member = member_fixture()
      assert Transfer.get_member!(member.id) == member
    end

    test "create_member/1 with valid data creates a member" do
      assert {:ok, %Member{} = member} = Transfer.create_member(@valid_attrs)
      assert member.nickname == "some nickname"
    end

    test "create_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transfer.create_member(@invalid_attrs)
    end

    test "update_member/2 with valid data updates the member" do
      member = member_fixture()
      assert {:ok, %Member{} = member} = Transfer.update_member(member, @update_attrs)
      assert member.nickname == "some updated nickname"
    end

    test "update_member/2 with invalid data returns error changeset" do
      member = member_fixture()
      assert {:error, %Ecto.Changeset{}} = Transfer.update_member(member, @invalid_attrs)
      assert member == Transfer.get_member!(member.id)
    end

    test "delete_member/1 deletes the member" do
      member = member_fixture()
      assert {:ok, %Member{}} = Transfer.delete_member(member)
      assert_raise Ecto.NoResultsError, fn -> Transfer.get_member!(member.id) end
    end

    test "change_member/1 returns a member changeset" do
      member = member_fixture()
      assert %Ecto.Changeset{} = Transfer.change_member(member)
    end
  end
end
