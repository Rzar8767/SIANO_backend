defmodule SianoWeb.BudgetController do
  use SianoWeb, :controller

  import SianoWeb.Authorize

  alias Siano.Transfer
  alias Siano.Transfer.Budget

  action_fallback SianoWeb.FallbackController

  plug :user_check when action in [:index, :create]
  plug :budget_member_check when action in [:show]
  plug :budget_owner_check when action in [:update, :delete]

  def index(%Plug.Conn{assigns: %{current_user: user}} = conn, _params) do
    budgets = Transfer.list_all_user_budgets(user.id)
    render(conn, "index.json", budgets: budgets)
  end

  def create(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"budget" => budget_params}) do
    budget_params = Map.put(budget_params, "owner_id", to_string(user.id))
    with {:ok, %Budget{} = budget} <- Transfer.create_budget(budget_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.budget_path(conn, :show, budget))
      |> render("show.json", budget: budget)
    end
  end
  # budget_member_check
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
      send_resp(conn, :ok, "{}")
    end
  end
end
