defmodule SianoWeb.ConfirmController do
  use SianoWeb, :controller

  import SianoWeb.Authorize

  alias Phauxth.Confirm
  alias Siano.Accounts
  alias SianoWeb.Email

  def index(conn, params) do
    case Confirm.verify(params) do
      {:ok, user} ->
        Accounts.confirm_user(user)
        Email.confirm_success(user.email)

        conn
        |> put_view(SianoWeb.ConfirmView)
        |> render("info.json", %{info: "Your account has been confirmed"})

      {:error, _message} ->
        error(conn, :unauthorized, 401)
    end
  end
end
