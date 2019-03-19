defmodule SianoWeb.Router do
  use SianoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SianoWeb do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
    resources "/budgets", BudgetController, except: [:new, :edit] do
      resources "/members", MemberController, except: [:new, :edit]
    end
  end
end
