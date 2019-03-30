defmodule SianoWeb.ShareController do
  use SianoWeb, :controller

  alias Siano.Transactions
  alias Siano.Transactions.Share

  action_fallback SianoWeb.FallbackController

  def index(conn, %{"budget_id" => budget_id, "transaction_id" => transaction_id}) do
    shares = Transactions.list_shares(budget_id, transaction_id)
    render(conn, "index.json", shares: shares)
  end

  def create(conn, %{"budget_id" => budget_id, "transaction_id" => transaction_id, "share" => share_params}) do
    with {:ok, %Share{} = share} <- Transactions.create_share(share_params, budget_id, transaction_id) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.budget_transaction_share_path(conn, :show, budget_id, transaction_id, share))
      |> render("show.json", share: share)
    end
  end

  def show(conn, %{"budget_id" => budget_id, "transaction_id" => transaction_id, "id" => id}) do
    share = Transactions.get_share!(id, budget_id, transaction_id)
    render(conn, "show.json", share: share)
  end

  def update(conn, %{"budget_id" => budget_id, "transaction_id" => transaction_id, "id" => id, "share" => share_params}) do
    share = Transactions.get_share!(id, budget_id, transaction_id)

    with {:ok, %Share{} = share} <- Transactions.update_share(share, share_params) do
      render(conn, "show.json", share: share)
    end
  end

  def delete(conn, %{"budget_id" => budget_id, "transaction_id" => transaction_id, "id" => id}) do
    share = Transactions.get_share!(id, budget_id, transaction_id)

    with {:ok, %Share{}} <- Transactions.delete_share(share) do
      send_resp(conn, :ok, "{}")
    end
  end
end
