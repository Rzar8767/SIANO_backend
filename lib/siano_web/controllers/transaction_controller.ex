defmodule SianoWeb.TransactionController do
  use SianoWeb, :controller

  import SianoWeb.Authorize

  alias Siano.Transactions
  alias Siano.Transactions.Transaction

  action_fallback SianoWeb.FallbackController

  plug :budget_member_check when action in [:index, :create, :show, :delete]

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, %{"budget_id" => budget_id}) do
    transactions = Transactions.list_transactions(budget_id)
                 #   |> Siano.Repo.preload([:shares])
    render(conn, "index.json", transactions: transactions)
  end

  def create(conn, %{"budget_id" => budget_id, "transaction" => transaction_params}) do
    with {:ok, %Transaction{} = transaction} <- Transactions.create_transaction(transaction_params, budget_id) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.budget_transaction_path(conn, :show, budget_id, transaction))
      |> render("show.json", transaction: transaction)
    end
  end

  def show(conn, %{"budget_id" => budget_id, "id" => id}) do
    transaction = Transactions.get_transaction!(id, budget_id)
    render(conn, "show.json", transaction: transaction)
  end

  def delete(conn, %{"budget_id" => budget_id, "id" => id}) do
    transaction = Transactions.get_transaction!(id, budget_id)

    with {:ok, %Transaction{}} <- Transactions.delete_transaction(transaction) do
      send_resp(conn, :ok, "{}")
    end
  end
end
