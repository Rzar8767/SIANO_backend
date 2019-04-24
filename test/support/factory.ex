defmodule Siano.Factory do
  use ExMachina.Ecto, repo: Siano.Repo

  def user_factory do
    %Siano.Accounts.User{
      username: sequence("Tester"),
      password: "Password",
      email: sequence(:email, &"test#{&1}@maxtracks.pl"),
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
      name: sequence("Soap"),
    }
  end

  def transaction_factory do
    budget = insert(:budget)
    #attrs = Map.put(%{}, :budget, budget)

    %Siano.Transactions.Transaction{
      title: "For cookies",
      date:  DateTime.from_naive!(~N[2011-05-18T15:00:01Z], "Etc/UTC"),
      budget: budget,
     # shares: [build(:share_raw, attrs)]
    }
  end

  def share_raw_factory(attrs) do
    budget = Map.get(attrs, :budget, insert(:budget))
    %Siano.Transactions.Share{
      amount: 2.5,
      member: build(:member, budget: nil, budget_id: budget.id),
    }
  end

  def share_factory(attrs) do
    budget = Map.get(attrs, :budget, insert(:budget))
    transaction = Map.get(attrs, :transaction, build(:transaction, budget: nil, budget_id: budget.id))
    %Siano.Transactions.Share{
      amount: 2.5,
      transaction: transaction,
      member: build(:member, budget: nil, budget_id: budget.id),
    }
  end
end
