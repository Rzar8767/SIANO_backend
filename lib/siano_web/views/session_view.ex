defmodule SianoWeb.SessionView do
  use SianoWeb, :view

  def render("info.json", %{info: token}) do
    %{access_token: token}
  end
end
