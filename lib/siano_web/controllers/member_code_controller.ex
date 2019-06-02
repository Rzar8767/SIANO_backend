defmodule SianoWeb.MemberCodeController do
  use SianoWeb, :controller

  import SianoWeb.Authorize

  alias Siano.Transfer
  alias Siano.Transfer.Member

  action_fallback SianoWeb.FallbackController

  plug :user_check when action in [:index, :create, :update]

  def index(conn, %{"code" => code}) do
    with {:ok, [budget_id, 1]} <- Siano.BudgetToken.decode(code) do
      Transfer.get_budget!(budget_id)
      budget_members = Transfer.list_free_budget_members(budget_id)
      render(conn, "index.json", budget_members: budget_members)
    end
  end

  def create(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"code" => code, "member" => member_params}) do
    with {:ok, [budget_id, seed]} <- Siano.BudgetToken.decode(code),
         {:ok, 1} <- verify_seed(seed),
        Transfer.get_budget!(budget_id),
         server_attrs = %{budget_id: budget_id, user_id: user.id},
         {:ok, %Member{} = member} <- Transfer.invitation_create_member(member_params, server_attrs) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.budget_member_path(conn, :show, budget_id, member))
      |> render("show.json", member: member)
    end
  end

  def update(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"code" => code, "id" => id, "member" => member_params}) do
    with {:ok, [budget_id, seed]} <- Siano.BudgetToken.decode(code),
         {:ok, 1} <- verify_seed(seed),
         member = Transfer.get_free_member!(id, budget_id),
         server_attrs = %{user_id: user.id},
         {:ok, %Member{} = member} <- Transfer.invitation_update_member(member, member_params, server_attrs) do
      render(conn, "show.json", member: member)
         end
  end

  defp verify_seed(1), do: {:ok, 1}
  defp verify_seed(_number), do: {:error, :not_found}


end
