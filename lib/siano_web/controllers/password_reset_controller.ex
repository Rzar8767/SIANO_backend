defmodule SianoWeb.PasswordResetController do
  use SianoWeb, :controller

  alias Phauxth.Confirm.PassReset
  alias Siano.Accounts
  alias SianoWeb.{Auth.Token, Email}

  def create(conn, %{"password_reset" => %{"email" => email}}) do
    if Accounts.create_password_reset(%{"email" => email}) do
      key = Token.sign(%{"email" => email})
      Email.reset_request(email, key)
    end

    conn
    |> put_status(:created)
    |> put_view(SianoWeb.PasswordResetView)
    |> render("info.json", %{info: "Check your inbox for instructions on how to reset your password"})
  end

  def update(conn, %{"password_reset" => user_params} = params) do
    case PassReset.verify(params, []) do
      {:ok, user} ->
        user
        |> Accounts.update_password(user_params)
        |> update_password(conn, params)

      {:error, message} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(SianoWeb.PasswordResetView)
        |> render("error.json", error: message)
    end
  end

  defp update_password({:ok, user}, conn, _params) do
    Email.reset_success(user.email)

    conn
    |> put_view(SianoWeb.PasswordResetView)
    |> render("info.json", %{info: "Your password has been reset"})
  end

  defp update_password({:error, %Ecto.Changeset{} = changeset}, conn, _params) do
    message = with p <- changeset.errors[:password], do: elem(p, 0)

    conn
    |> put_status(:unprocessable_entity)
    |> put_view(SianoWeb.PasswordResetView)
    |> render("error.json", error: message)
  end
end
