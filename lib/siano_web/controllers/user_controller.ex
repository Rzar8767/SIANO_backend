defmodule SianoWeb.UserController do
  use SianoWeb, :controller

  import SianoWeb.Authorize

  alias Phauxth.Log
  alias Siano.Accounts
  alias SianoWeb.{Auth.Token, Email}

  action_fallback SianoWeb.FallbackController

  # the following plugs are defined in the controllers/authorize.ex file
  plug :user_check when action in [:index, :current]
  plug :id_check when action in [:update, :show, :delete]

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => %{"email" => email} = user_params}) do
    key = Token.sign(%{"email" => email})
    with {:ok, user} <- Accounts.create_user(user_params) do
      Log.info(%Log{user: user.id, message: "user created"})
      Email.confirm_request(email, key)
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def current(%Plug.Conn{assigns: %{current_user: user}} = conn, _params) do
    render(conn, "show.json", user: user)
  end

  def show(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    user = if id == to_string(user.id), do: user, else: Accounts.get_user(id)
    render(conn, "show.json", user: user)
  end

  def update(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(%Plug.Conn{assigns: %{current_user: user}} = conn, _) do
    {:ok, _user} = Accounts.delete_user(user)
    send_resp(conn, :ok, "{}")
  end
end
