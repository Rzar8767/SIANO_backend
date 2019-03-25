defmodule SianoWeb.TransactionView do
  use SianoWeb, :view
  alias SianoWeb.TransactionView

  def render("index.json", %{transactions: transactions}) do
    %{data: render_many(transactions, TransactionView, "transaction.json")}
  end

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, TransactionView, "transaction.json")}
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{id: transaction.id,
      title: transaction.title,
      date: transaction.date,
      category_id: transaction.category_id}
  end
end
