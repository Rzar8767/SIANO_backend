defmodule SianoWeb.MemberController do
  use SianoWeb, :controller

  import SianoWeb.Authorize

  alias Siano.Transfer
  alias Siano.Transfer.Member

  action_fallback SianoWeb.FallbackController

  plug :budget_member_check when action in [:index, :show]
  plug :budget_owner_check when action in [:create, :update, :delete]

  def index(conn, %{"budget_id" => budget_id}) do
    budget_members = Transfer.list_budget_members(budget_id)
    render(conn, "index.json", budget_members: budget_members)
  end

  def create(conn, %{"budget_id" => budget_id, "member" => member_params}) do
    with {:ok, %Member{} = member} <- Transfer.create_member(member_params, budget_id) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.budget_member_path(conn, :show, budget_id, member))
      |> render("show.json", member: member)
    end
  end

  def show(conn, %{"budget_id" => budget_id, "id" => id}) do
    member = Transfer.get_member!(id, budget_id)
    render(conn, "show.json", member: member)
  end

  def update(conn, %{"budget_id" => budget_id, "id" => id, "member" => member_params}) do
    member = Transfer.get_member!(id, budget_id)

    with {:ok, %Member{} = member} <- Transfer.update_member(member, member_params) do
      render(conn, "show.json", member: member)
    end
  end

  def delete(conn, %{"budget_id" => budget_id, "id" => id}) do
    member = Transfer.get_member!(id, budget_id)

    with {:ok, %Member{}} <- Transfer.delete_member(member) do
      send_resp(conn, :ok, "{}")
    end
  end
end
