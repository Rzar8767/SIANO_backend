defmodule Siano.Factory do
  use ExMachina.Ecto, repo: Siano.Repo

  def user_factory do
    %Siano.Accounts.User{
      username: sequence("Tester"),
      password: "Password",
      email: sequence(:email, &"test#{&1}@maxtracks.pl"),
      is_active: false,
    }
  end
# make it do <build> and put id from build or set belongs_to in the model
  def budget_factory do
    %Siano.Transfer.Budget{
      name: "Expenses",
      color: "#52AAFF",
      owner: build(:user),
    }
  end

  def member_factory do
    %Siano.Transfer.Member{
      nickname: "Pajeet",
      budget: build(:budget),
    }
  end

  def category_factory do
    %Siano.Transactions.Category{
      name: sequence("Mydło"),
    }
  end

  def transaction_factory do
    %Siano.Transactions.Transaction{
      title: "For cookies",
      date:  DateTime.from_naive!(~N[2011-05-18T15:00:01Z], "Etc/UTC"),
      budget: build(:budget),
    }
  end

  def share_factory do
    budget = insert(:budget)
    %Siano.Transactions.Share{
      amount: 2.5,
      transaction: build(:transaction, budget: nil, budget_id: budget.id),
      member: build(:member, budget: nil, budget_id: budget.id),
    }
  end
end
