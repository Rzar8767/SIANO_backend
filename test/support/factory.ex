defmodule Siano.Factory do
  use ExMachina.Ecto, repo: Siano.Repo

  def user_factory do
    %Siano.Accounts.User{
      username: sequence("Tester"),
      password: "Password",
      password_hash: "53ta90t30a9t",
      email: sequence(:email, &"test#{&1}@maxtracks.pl"),
      is_active: false,
    }
  end
# make it do <build> and put id from build or set belongs_to in the model
  def budget_factory do
    %Siano.Transfer.Budget{
      name: "Expenses",
      color: "#52AAFF",
      owner_id: build(:user),
    }
  end

  def member_factory do
    %Siano.Transfer.Member{
      nickname: "Pajeet",
      budget_id: build(:budget),
    }
  end

end
