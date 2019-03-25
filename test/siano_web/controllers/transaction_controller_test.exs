defmodule SianoWeb.TransactionControllerTest do
  use SianoWeb.ConnCase
  import Siano.Factory

  alias Siano.Transactions.Transaction

  @create_attrs %{
    title: "some title",
    date: "2010-04-17T14:00:00Z"
  }
  @update_attrs %{
    title: "some updated title",
    date: "2011-05-18T15:01:01Z"
  }
  @invalid_attrs %{title: nil, date: nil}


  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all transactions", %{conn: conn} do
      budget = insert(:budget)
      conn = get(conn, Routes.budget_transaction_path(conn, :index, budget.id))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create transaction" do
    test "renders transaction when data is valid", %{conn: conn} do
      budget = insert(:budget)
      conn = post(conn, Routes.budget_transaction_path(conn, :create, budget.id), transaction: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.budget_transaction_path(conn, :show, budget.id, id))

      assert %{
               "id" => id,
               "title" => "some title",
               "category_id" => nil,
               "date" => "2010-04-17T14:00:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      budget = insert(:budget)
      conn = post(conn, Routes.budget_transaction_path(conn, :create, budget.id), transaction: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update transaction" do
    setup [:create_transaction]

    test "renders transaction when data is valid", %{conn: conn, transaction: %Transaction{id: id} = transaction} do
      conn = put(conn, Routes.budget_transaction_path(conn, :update, transaction.budget_id, transaction), transaction: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.budget_transaction_path(conn, :show, transaction.budget_id, id))

      assert %{
               "id" => id,
               "title" => "some updated title",
               "date" => "2011-05-18T15:01:01Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, transaction: transaction} do
      conn = put(conn, Routes.budget_transaction_path(conn, :update, transaction.budget_id, transaction), transaction: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete transaction" do
    setup [:create_transaction]

    test "deletes chosen transaction", %{conn: conn, transaction: transaction} do
      conn = delete(conn, Routes.budget_transaction_path(conn, :delete, transaction.budget_id, transaction))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.budget_transaction_path(conn, :show, transaction.budget_id, transaction))
      end
    end
  end

  defp create_transaction(_) do
    transaction = insert(:transaction, @create_attrs)
    {:ok, transaction: transaction}
  end
end
