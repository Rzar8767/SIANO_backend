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

end
