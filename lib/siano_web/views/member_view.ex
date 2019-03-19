defmodule SianoWeb.MemberView do
  use SianoWeb, :view
  alias SianoWeb.MemberView

  def render("index.json", %{budget_members: budget_members}) do
    %{data: render_many(budget_members, MemberView, "member.json")}
  end

  def render("show.json", %{member: member}) do
    %{data: render_one(member, MemberView, "member.json")}
  end

  def render("member.json", %{member: member}) do
    %{id: member.id,
      nickname: member.nickname,
      user_id: member.user_id}
  end
end
