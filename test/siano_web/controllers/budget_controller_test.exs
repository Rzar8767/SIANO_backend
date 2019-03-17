defmodule SianoWeb.BudgetControllerTest do
  use SianoWeb.ConnCase

  alias Siano.Transfer
  alias Siano.Transfer.Budget

  @create_attrs %{
    color: "some color",
    name: "some name"
  }
  @update_attrs %{
    color: "some updated color",
    name: "some updated name"
  }
  @invalid_attrs %{color: nil, name: nil}

  def fixture(:budget) do
    {:ok, budget} = Transfer.create_budget(@create_attrs)
    budget
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all budgets", %{conn: conn} do
      conn = get(conn, Routes.budget_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create budget" do
    test "renders budget when data is valid", %{conn: conn} do
      conn = post(conn, Routes.budget_path(conn, :create), budget: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.budget_path(conn, :show, id))

      assert %{
               "id" => id,
               "color" => "some color",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.budget_path(conn, :create), budget: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update budget" do
    setup [:create_budget]

    test "renders budget when data is valid", %{conn: conn, budget: %Budget{id: id} = budget} do
      conn = put(conn, Routes.budget_path(conn, :update, budget), budget: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.budget_path(conn, :show, id))

      assert %{
               "id" => id,
               "color" => "some updated color",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, budget: budget} do
      conn = put(conn, Routes.budget_path(conn, :update, budget), budget: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete budget" do
    setup [:create_budget]

    test "deletes chosen budget", %{conn: conn, budget: budget} do
      conn = delete(conn, Routes.budget_path(conn, :delete, budget))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.budget_path(conn, :show, budget))
      end
    end
  end

  defp create_budget(_) do
    budget = fixture(:budget)
    {:ok, budget: budget}
  end
end
