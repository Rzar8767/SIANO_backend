defmodule SianoWeb.MemberCodeView do
  use SianoWeb, :view
  alias SianoWeb.MemberCodeView

  def render("index.json", %{budget_members: budget_members}) do
    %{data: render_many(budget_members, MemberCodeView, "member.json", as: :member)}
  end

  def render("show.json", %{member: member}) do
    %{data: render_one(member, MemberCodeView, "member.json", as: :member)}
  end

  def render("member.json", %{member: member}) do
    %{id: member.id,
      nickname: member.nickname,
      user_id: member.user_id}
  end
end
