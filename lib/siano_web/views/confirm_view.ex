defmodule SianoWeb.ConfirmView do
  use SianoWeb, :view

  def render("info.json", %{info: message}) do
    %{info: %{detail: message}}
  end
end
