defmodule Siano.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias Siano.Sessions.Session

  @type t :: %__MODULE__{
    id: integer,
    email: String.t(),
    username: String.t(),
    password_hash: String.t(),
    confirmed_at: DateTime.t() | nil,
    reset_sent_at: DateTime.t() | nil,
    sessions: %Ecto.Association.NotLoaded{} | [Session.t()],
    inserted_at: DateTime.t(),
    updated_at: DateTime.t()
  }

  schema "users" do
    field :email, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :confirmed_at, :utc_datetime
    field :reset_sent_at, :utc_datetime
    has_many :sessions, Session, on_delete: :delete_all
    has_many :budgets, Siano.Transfer.Budget, foreign_key: :owner_id
    many_to_many :budget_members, Siano.Transfer.Budget, join_through: "budget_members"

    timestamps(type: :utc_datetime)
  end

  def changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> unique_email
  end

  def create_changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password, :username])
    |> validate_required([:email, :password, :username])
    |> unique_email
    |> unique_constraint(:username)
    |> validate_password(:password)
    |> put_pass_hash
  end

  def confirm_changeset(%__MODULE__{} = user) do
    change(user, %{confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second)})
  end

  def password_reset_changeset(%__MODULE__{} = user, reset_sent_at) do
    change(user, %{reset_sent_at: reset_sent_at})
  end

  def password_updated_changeset(changeset) do
    change(changeset, %{reset_sent_at: nil})
  end

  defp unique_email(changeset) do
    validate_format(changeset, :email, ~r/@/)
    |> validate_length(:email, max: 254)
    |> unique_constraint(:email)
  end

  # In the function below, strong_password? just checks that the password
  # is at least 8 characters long.
  # See the documentation for NotQwerty123.PasswordStrength.strong_password?
  # for a more comprehensive password strength checker.
  defp validate_password(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, password ->
      case strong_password?(password) do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || msg}]
      end
    end)
  end

  # If you are using Bcrypt or Pbkdf2, change Argon2 to Bcrypt or Pbkdf2
  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes:
      %{password: password}} = changeset) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset

  defp strong_password?(password) when byte_size(password) > 7 do
    {:ok, password}
  end

  defp strong_password?(_), do: {:error, "The password is too short"}
end
