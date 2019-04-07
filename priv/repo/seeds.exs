# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Siano.Repo.insert!(%Siano.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

users = [
  %{email: "marek@example.com", username: "marek", password: "password"},
  %{email: "wiktor@maxtracks.pl", username: "Wiktor", password: "password"},
  %{email: "marcin@maxtracks.pl", username: "Marcin", password: "password"},
  %{email: "kilogram@cebuli.pl", username: "Cebula", password: "password"}
]

# Activate users
for user <- users do
  {:ok, user} = Siano.Accounts.create_user(user)
  Siano.Accounts.confirm_user(user)
end

# Create some budgets
budgets = [
  %{name: "Moi koledzy", color: "#ffffff", owner_id: 1},
  %{name: "Skutery", color: "#aaaaaa", owner_id: 2}
]

for budget <- budgets do
  {:ok, budget} = Siano.Transfer.create_budget(budget)
  owner = Siano.Accounts.get_by(%{"user_id" => budget.owner_id})
  {:ok, _member} = Siano.Transfer.create_member(%{nickname: owner.username,
                                                user_id: budget.owner_id }, budget.id)
end

members = [
  %{nickname: "Jarek"},
  %{nickname: "Czarek"},
  %{nickname: "Darek"},
  %{nickname: "Arek"}
]

for member <- members do
  {:ok, _member} = Siano.Transfer.create_member(member, 1)
end

categories = [
  %Siano.Transactions.Category{name: "Skuter"},
  %Siano.Transactions.Category{name: "Cebula"},
  %Siano.Transactions.Category{name: "Maslo"}
]

for category <- categories do
  Siano.Repo.insert!(category)
end
