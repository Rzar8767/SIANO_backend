defmodule SianoWeb.ShareView do
  use SianoWeb, :view
  alias SianoWeb.ShareView

  def render("index.json", %{shares: shares}) do
    %{data: render_many(shares, ShareView, "share.json")}
  end

  def render("show.json", %{share: share}) do
    %{data: render_one(share, ShareView, "share.json")}
  end

  def render("share.json", %{share: share}) do
    %{id: share.id,
      amount: share.amount,
      member_id: share.member_id}
  end
end
