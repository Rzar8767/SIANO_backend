defmodule SianoWeb.MemberControllerTest do
  use SianoWeb.ConnCase
  import Siano.Factory

  alias Siano.Transfer.Member

  @create_attrs %{
    nickname: "some nickname"
  }
  @update_attrs %{
    nickname: "some updated nickname"
  }
  @invalid_attrs %{nickname: nil}


  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all budget_members belonging to a single budget", %{conn: conn} do
      budget = insert(:budget)
      conn = get(conn, Routes.budget_member_path(conn, :index, budget.id))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create member" do
    test "renders member when data is valid", %{conn: conn} do
      budget = insert(:budget)
      conn = post(conn, Routes.budget_member_path(conn, :create, budget.id), member: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.budget_member_path(conn, :show, budget.id, id))

      assert %{
               "id" => id,
               "nickname" => "some nickname"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      budget = insert(:budget)
      conn = post(conn, Routes.budget_member_path(conn, :create, budget.id), member: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update member" do
    setup [:create_member]

    test "renders member when data is valid", %{conn: conn, member: %Member{id: id} = member} do
      conn = put(conn, Routes.budget_member_path(conn, :update, member.budget_id, member), member: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.budget_member_path(conn, :show, member.budget_id, id))

      assert %{
               "id" => id,
               "nickname" => "some updated nickname"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, member: member} do
      conn = put(conn, Routes.budget_member_path(conn, :update, member.budget_id, member), member: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete member" do
    setup [:create_member]

    test "deletes chosen member", %{conn: conn, member: member} do
      conn = delete(conn, Routes.budget_member_path(conn, :delete, member.budget_id, member))
      assert response(conn, 200)

      assert_error_sent 404, fn ->
        get(conn, Routes.budget_member_path(conn, :show, member.budget_id, member))
      end
    end
  end

  defp create_member(_) do
    member = insert(:member, @create_attrs)
    {:ok, member: member}
  end
end
