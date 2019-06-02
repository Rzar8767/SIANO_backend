defmodule SianoWeb.Router do
  use SianoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Phauxth.AuthenticateToken
  end

  scope "/api", SianoWeb do
    pipe_through :api

    post "/sessions", SessionController, :create
    get "/confirm", ConfirmController, :index
    post "/password_resets", PasswordResetController, :create
    put "/password_resets/update", PasswordResetController, :update
    get "/me", UserController, :current

    get "/budgets/code/:code/members", MemberCodeController, :index
    post "/budgets/code/:code/members", MemberCodeController, :create
    put "/budgets/code/:code/members/:id", MemberCodeController, :update

    resources "/users", UserController, except: [:new, :edit]
    resources "/budgets", BudgetController, except: [:new, :edit] do
      resources "/members", MemberController, except: [:new, :edit]
      resources "/transactions", TransactionController, except: [:new, :edit, :update] do
        resources "/shares", ShareController, except: [:new, :edit]
      end
    end
  end
end
