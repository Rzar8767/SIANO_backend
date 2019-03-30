defmodule SianoWeb.ShareControllerTest do
  use SianoWeb.ConnCase
  import Siano.Factory

  alias Siano.Transactions.Share

  @create_attrs %{
    amount: 120.5
  }
  @update_attrs %{
    amount: 456.7
  }
  @invalid_attrs %{amount: nil, member_id: -1}


  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all shares", %{conn: conn} do
      transaction = insert(:transaction)
      conn = get(conn, Routes.budget_transaction_share_path(conn, :index, transaction.budget_id, transaction.id))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create share" do
    test "renders share when data is valid", %{conn: conn} do
      share = insert(:share)

      conn = post(conn, Routes.budget_transaction_share_path(conn, :create, share.transaction.budget_id, share.transaction_id), share: Map.put(@create_attrs, :member_id, share.member_id))
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.budget_transaction_share_path(conn, :show, share.transaction.budget_id, share.transaction_id, id))

      assert %{
               "id" => id,
               "amount" => "120.5"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      share = insert(:share)
      conn = post(conn, Routes.budget_transaction_share_path(conn, :create, share.transaction.budget_id, share.transaction_id), share: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update share" do
    setup [:create_share]

    test "renders share when data is valid", %{conn: conn, share: %Share{id: id} = share} do
      conn = put(conn, Routes.budget_transaction_share_path(conn, :update, share.transaction.budget_id, share.transaction_id, share), share: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.budget_transaction_share_path(conn, :show, share.transaction.budget_id, share.transaction_id, id))

      assert %{
               "id" => id,
               "amount" => "456.7"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, share: share} do
      conn = put(conn, Routes.budget_transaction_share_path(conn, :update, share.transaction.budget_id, share.transaction_id, share), share: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete share" do
    setup [:create_share]

    test "deletes chosen share", %{conn: conn, share: share} do
      conn = delete(conn, Routes.budget_transaction_share_path(conn, :delete, share.transaction.budget_id, share.transaction_id, share))
      assert response(conn, 200)

      assert_error_sent 404, fn ->
        get(conn, Routes.budget_transaction_share_path(conn, :show, share.transaction.budget_id, share.transaction_id, share))
      end
    end
  end

  defp create_share(_) do
    share = insert(:share)
    {:ok, share: share}
  end
end
