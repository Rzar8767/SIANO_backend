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

Siano.Repo.insert!(%Siano.Transactions.Category{name: "Ciastko"})
Siano.Repo.insert!(%Siano.Transactions.Category{name: "Cebula"})
Siano.Repo.insert!(%Siano.Transactions.Category{name: "Masło"})
