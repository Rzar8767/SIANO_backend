defmodule SianoWeb.MemberController do
  use SianoWeb, :controller

  alias Siano.Transfer
  alias Siano.Transfer.Member

  action_fallback SianoWeb.FallbackController

  def index(conn, %{"budget_id" => budget_id}) do
    budget_members = Transfer.list_budget_members(budget_id)
    render(conn, "index.json", budget_members: budget_members)
  end

  def create(conn, %{"budget_id" => budget_id, "member" => member_params}) do
    with {:ok, %Member{} = member} <- Transfer.create_member(budget_id, member_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.budget_member_path(conn, :show, budget_id, member))
      |> render("show.json", member: member)
    end
  end

  def show(conn, %{"budget_id" => budget_id, "id" => id}) do
    member = Transfer.get_member!(budget_id, id)
    render(conn, "show.json", member: member)
  end

  def update(conn, %{"budget_id" => budget_id, "id" => id, "member" => member_params}) do
    member = Transfer.get_member!(budget_id, id)

    with {:ok, %Member{} = member} <- Transfer.update_member(member, member_params) do
      render(conn, "show.json", member: member)
    end
  end

  def delete(conn, %{"budget_id" => budget_id, "id" => id}) do
    member = Transfer.get_member!(budget_id, id)

    with {:ok, %Member{}} <- Transfer.delete_member(member) do
      send_resp(conn, :no_content, "")
    end
  end
end
