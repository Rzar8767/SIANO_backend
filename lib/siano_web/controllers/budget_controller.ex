defmodule SianoWeb.BudgetController do
  use SianoWeb, :controller

  alias Siano.Transfer
  alias Siano.Transfer.Budget

  action_fallback SianoWeb.FallbackController

  def index(conn, _params) do
    budgets = Transfer.list_budgets()
    render(conn, "index.json", budgets: budgets)
  end

  def create(conn, %{"budget" => budget_params}) do
    with {:ok, %Budget{} = budget} <- Transfer.create_budget(budget_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.budget_path(conn, :show, budget))
      |> render("show.json", budget: budget)
    end
  end

  def show(conn, %{"id" => id}) do
    budget = Transfer.get_budget!(id)
    render(conn, "show.json", budget: budget)
  end

  def update(conn, %{"id" => id, "budget" => budget_params}) do
    budget = Transfer.get_budget!(id)

    with {:ok, %Budget{} = budget} <- Transfer.update_budget(budget, budget_params) do
      render(conn, "show.json", budget: budget)
    end
  end

  def delete(conn, %{"id" => id}) do
    budget = Transfer.get_budget!(id)

    with {:ok, %Budget{}} <- Transfer.delete_budget(budget) do
      send_resp(conn, :ok, "deleted")
    end
  end
end
