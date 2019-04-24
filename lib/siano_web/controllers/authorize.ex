defmodule SianoWeb.Authorize do
  @moduledoc """
  Functions to help with authorization.

  See the [Authorization wiki page](https://github.com/riverrun/phauxth/wiki/Authorization)
  for more information and examples about authorization.
  """

  import Plug.Conn
  import Phoenix.Controller

  @doc """
  Plug to only allow authenticated users to access the resource.

  See the user controller for an example.
  """
  def user_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    error(conn, :unauthorized, 401)
  end

  def user_check(conn, _opts), do: conn

  @doc """
  Plug to only allow unauthenticated users to access the resource.

  See the session controller for an example.
  """
  def guest_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts), do: conn

  def guest_check(%Plug.Conn{assigns: %{current_user: _current_user}} = conn, _opts) do
    conn
    |> put_status(:unauthorized)
    |> put_view(SianoWeb.AuthView)
    |> render("logged_in.json", [])
    |> halt()
  end

  @doc """
  Plug to only allow authenticated users with the correct id to access the resource.

  See the user controller for an example.
  """
  def id_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    error(conn, :unauthorized, 401)
  end

  def id_check(
        %Plug.Conn{params: %{"id" => id}, assigns: %{current_user: current_user}} = conn,
        _opts
      ) do
    if id == to_string(current_user.id) do
      conn
    else
      error(conn, :forbidden, 403)
    end
  end

  @doc """
  Plug to allow owners and members of budgets to access the resource.
  """
  def budget_member_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    error(conn, :unauthorized, 401)
  end

  def budget_member_check(
    %Plug.Conn{params: %{"budget_id" => budget_id}} = conn, _opts) do
      budget_member_do_check(conn, budget_id)
  end

  def budget_member_check(
    %Plug.Conn{params: %{"id" => budget_id}} = conn, _opts) do
      budget_member_do_check(conn, budget_id)
  end

  defp budget_member_do_check(
        %Plug.Conn{assigns: %{current_user: user}} = conn,
        budget_id
      ) do
    owner_exists = Siano.Transfer.budget_exists?(%{"id" => budget_id, "owner_id" => user.id})
    member_exists = Siano.Transfer.member_exists?(%{"budget_id" => budget_id, "user_id" => user.id})
    if owner_exists || member_exists do
      conn
    else
      error(conn, :not_found, 404)
    end
  end

  @doc """
  Plug to only allow owners of budgets to access the resource.
  """

  def budget_owner_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    error(conn, :unauthorized, 401)
  end

  def budget_owner_check(
    %Plug.Conn{params: %{"budget_id" => budget_id}} = conn, _opts) do
      budget_owner_do_check(conn, budget_id)
  end

  def budget_owner_check(
    %Plug.Conn{params: %{"id" => budget_id}} = conn, _opts) do
      budget_owner_do_check(conn, budget_id)
  end

  defp budget_owner_do_check(
        %Plug.Conn{assigns: %{current_user: user}} = conn,
        budget_id
      ) do
    budget = Siano.Transfer.get_budget!(budget_id)
    if budget.owner_id == user.id do
      conn
    else
      error(conn, :not_found, 404)
    end
  end

  def error(conn, status, code) do
    put_status(conn, status)
    |> put_view(SianoWeb.AuthView)
    |> render("#{code}.json", [])
    |> halt()
  end
end
