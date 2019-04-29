defmodule Siano.Transfer do
  @moduledoc """
  The Transfer context.
  """

  import Ecto.Query, warn: false
  alias Siano.Repo

  alias Siano.Transfer.Budget

  @doc """
  Returns the list of budgets.

  ## Examples

      iex> list_budgets()
      [%Budget{}, ...]

  """
  def list_budgets do
    Repo.all(Budget)
  end

  def list_all_user_budgets(user_id) do
    member_query =
      from b in Budget,
        join: m in assoc(b, :members),
        where: m.user_id == ^user_id,
        select: b

    owner_and_member_query =
      from b in Budget,
      where: b.owner_id == ^user_id,
      union: ^member_query

    Repo.all(owner_and_member_query)
  end

  @doc """
  Gets a single budget.

  Raises `Ecto.NoResultsError` if the Budget does not exist.

  ## Examples

      iex> get_budget!(123)
      %Budget{}

      iex> get_budget!(456)
      ** (Ecto.NoResultsError)

  """
  def get_budget!(id), do: Repo.get!(Budget, id)

  def get_owned_budgets(user_id) do
    query = from b in Budget, where: b.owner_id == ^user_id
    Repo.all(query)
  end

  def budget_exists?(%{"id" => id, "owner_id" => owner_id}) do
    query = from b in Budget, where: b.id == ^id and b.owner_id == ^owner_id
    Repo.exists?(query)
  end

  @doc """
  Creates a budget.

  ## Examples

      iex> create_budget(%{field: value})
      {:ok, %Budget{}}

      iex> create_budget(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_budget(attrs \\ %{}) do
    %Budget{}
    |> Budget.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a budget.

  ## Examples

      iex> update_budget(budget, %{field: new_value})
      {:ok, %Budget{}}

      iex> update_budget(budget, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_budget(%Budget{} = budget, attrs) do
    budget
    |> Budget.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Budget.

  ## Examples

      iex> delete_budget(budget)
      {:ok, %Budget{}}

      iex> delete_budget(budget)
      {:error, %Ecto.Changeset{}}

  """
  def delete_budget(%Budget{} = budget) do
    Repo.delete(budget)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking budget changes.

  ## Examples

      iex> change_budget(budget)
      %Ecto.Changeset{source: %Budget{}}

  """
  def change_budget(%Budget{} = budget) do
    Budget.changeset(budget, %{})
  end

  alias Siano.Transfer.Member

  @doc """
  Returns the list of budget_members.
  The parameter is the budget's id.

  ## Examples

      iex> list_budget_members(6)
      [%Member{}, ...]

  """
  def list_budget_members(budget_id) do
    Member
    |> where([u], u.budget_id == ^budget_id)
    |> Repo.all()
  end

  @doc """
  Return the list of budget_members that have no users attached to them.
   The parameter is the budget's id.
  """
  def list_free_budget_members(budget_id) do
    Member
    |> where([u], u.budget_id == ^budget_id)
    |> where([u], is_nil(u.user_id))
    |> Repo.all()
  end

  @doc """
  Gets a single member.

  Raises `Ecto.NoResultsError` if the Member does not exist.

  ## Examples

      iex> get_member!(123)
      %Member{}

      iex> get_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_member!(id, budget_id) do
  Member
  |> where([u], u.budget_id == ^budget_id)
  |> Repo.get!(id)
  end

  def get_free_member!(id, budget_id) do
  Member
  |> where([u], u.budget_id == ^budget_id)
  |> where([u], is_nil(u.user_id))
  |> Repo.get!(id)
  end

  def member_exists?(%{"budget_id" => budget_id, "user_id" => user_id}) do
    query = from m in Member, where: m.budget_id == ^budget_id and m.user_id == ^user_id
    Repo.exists?(query)
  end

  @doc """
  Creates a member.
  The second parameter is the budget_id for his budget.

  ## Examples

      iex> create_member(%{field: value}, 8)
      {:ok, %Member{}}

      iex> create_member(%{field: bad_value}, 8)
      {:error, %Ecto.Changeset{}}

  """
  def create_member(attrs \\ %{}, budget_id)

  def create_member(attrs, budget_id) when is_binary(budget_id) do
    budget_val = budget_id |> Integer.parse(10) |> elem(0)
    create_member(attrs, budget_val)
  end

  def create_member(attrs, budget_id) do
    %Member{}
    |> Member.changeset(attrs)
    |> Ecto.Changeset.change(budget_id: budget_id)
    |> Repo.insert()
  end

  @doc """
  Creates a member, server sets user_id and budget_id.

  ## Examples

      iex> invitation_create_member(%{field: value}, %{user_id: 2, budget_id: 1})
      {:ok, %Member{}}

      iex> invitation_create_member(%{field: bad_value}, 8)
      {:error, %Ecto.Changeset{}}

  """
  def invitation_create_member(attrs \\ %{}, server_attrs \\ %{}) do
    %Member{}
    |> Ecto.Changeset.change(server_attrs)
    |> Member.invitation_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a member.

  ## Examples

      iex> update_member(member, %{field: new_value})
      {:ok, %Member{}}

      iex> update_member(member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_member(%Member{} = member, attrs) do
    member
    |> Member.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a member, server sets user_id.

  ## Examples

      iex> update_member(member, %{field: new_value})
      {:ok, %Member{}}

      iex> update_member(member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def invitation_update_member(%Member{} = member, attrs \\ %{}, server_attrs \\ %{}) do
    member
    |> Ecto.Changeset.change(server_attrs)
    |> Member.invitation_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Member.

  ## Examples

      iex> delete_member(member)
      {:ok, %Member{}}

      iex> delete_member(member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_member(%Member{} = member) do
    member
    |> Repo.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking member changes.

  ## Examples

      iex> change_member(member)
      %Ecto.Changeset{source: %Member{}}

  """
  def change_member(%Member{} = member) do
    Member.changeset(member, %{})
  end
end
