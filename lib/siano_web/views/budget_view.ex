defmodule SianoWeb.BudgetView do
  use SianoWeb, :view
  alias SianoWeb.BudgetView

  def render("index.json", %{budgets: budgets}) do
    %{data: render_many(budgets, BudgetView, "budget.json")}
  end

  def render("show.json", %{budget: budget}) do
    %{data: render_one(budget, BudgetView, "budget.json")}
  end

  def render("budget.json", %{budget: budget}) do
    %{id: budget.id,
      name: budget.name,
      color: budget.color,
      owner_id: budget.owner_id,
      invite_code: Siano.BudgetToken.encode(budget.id, 1)
    }
  end
end
