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
  %Siano.Transactions.Category{name: "Other"},
  %Siano.Transactions.Category{name: "Company"},
  %Siano.Transactions.Category{name: "Food at home"},
  %Siano.Transactions.Category{name: "Food out"},
  %Siano.Transactions.Category{name: "Internet"},
  %Siano.Transactions.Category{name: "Phone"},
  %Siano.Transactions.Category{name: "TV"},
  %Siano.Transactions.Category{name: "Rent"},
  %Siano.Transactions.Category{name: "Energy"},
  %Siano.Transactions.Category{name: "Gas"},
  %Siano.Transactions.Category{name: "Water"},
  %Siano.Transactions.Category{name: "Flat maintenance"},
  %Siano.Transactions.Category{name: "Shoes"},
  %Siano.Transactions.Category{name: "Clothes"},
  %Siano.Transactions.Category{name: "Fees"},
  %Siano.Transactions.Category{name: "Attractions"},
  %Siano.Transactions.Category{name: "Public transport"},
  %Siano.Transactions.Category{name: "Accommodation"},
  %Siano.Transactions.Category{name: "Accessories"},
  %Siano.Transactions.Category{name: "Hobby"},
  %Siano.Transactions.Category{name: "Alcohol"},
  %Siano.Transactions.Category{name: "Drugs"},
  %Siano.Transactions.Category{name: "Games"},
  %Siano.Transactions.Category{name: "Theater"},
  %Siano.Transactions.Category{name: "Cinema"},
  %Siano.Transactions.Category{name: "Concerts"},
  %Siano.Transactions.Category{name: "Books"},
  %Siano.Transactions.Category{name: "Subscription"},
  %Siano.Transactions.Category{name: "Car maintenance"},
  %Siano.Transactions.Category{name: "Fuel"},
  %Siano.Transactions.Category{name: "Parking"},
  %Siano.Transactions.Category{name: "Car insurance"},
  %Siano.Transactions.Category{name: "Health care"},
  %Siano.Transactions.Category{name: "Hygiene"},
  %Siano.Transactions.Category{name: "Sport"},
  %Siano.Transactions.Category{name: "Cosmetics"},
  %Siano.Transactions.Category{name: "Medicine"},
  %Siano.Transactions.Category{name: "Charity"},
  %Siano.Transactions.Category{name: "Gift"},
  %Siano.Transactions.Category{name: "Reserve 1"},
  %Siano.Transactions.Category{name: "Reserve 2"},
  %Siano.Transactions.Category{name: "Reserve 3"},
  %Siano.Transactions.Category{name: "Reserve 4"},
  %Siano.Transactions.Category{name: "Reserve 5"}
]

for category <- categories do
  Siano.Repo.insert!(category)
end
