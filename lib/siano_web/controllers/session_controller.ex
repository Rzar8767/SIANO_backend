defmodule SianoWeb.SessionController do
  use SianoWeb, :controller

  import SianoWeb.Authorize

  #alias Phauxth.Remember
  alias Siano.Sessions
  alias SianoWeb.Auth.Login
  alias SianoWeb.Auth.Token

  # the following plug is defined in the controllers/authorize.ex file
  plug :guest_check when action in [:create]

  def create(conn, %{"session" => params}) do
    case Login.verify(params) do
      {:ok, user} ->
        # The Sessions.create_session function is only needed if you are tracking
        # sessions in the database. If you do not want to store session data in the
        # database, remove this line, the Siano.Sessions alias and the
        # Siano.Sessions and Siano.Sessions.Session modules
        {:ok, %{id: session_id}} = Sessions.create_session(%{user_id: user.id})
        token = Token.sign(%{"session_id" => session_id})
        render(conn, "info.json", %{info: token})
      {:error, _message} ->
        error(conn, :unauthorized, 401)
    end
  end
end
