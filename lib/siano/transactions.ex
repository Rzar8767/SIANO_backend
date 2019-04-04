defmodule Siano.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Siano.Repo

  alias Siano.Transactions.Transaction

  @doc """
  Returns the list of transactions belonging to a single budget.

  ## Examples

      iex> list_transactions(1)
      [%Transaction{}, ...]

  """
  def list_transactions(budget_id) do
    Transaction
    |> where([t], t.budget_id == ^budget_id)
    |> preload(:shares)
    |> Repo.all()
  end

  @doc """
  Gets a single transaction belonging to a specific budget.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123, 1)
      %Transaction{}

      iex> get_transaction!(456, 1)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id, budget_id) do
    Transaction
    |> where([t], t.budget_id == ^budget_id)
    |> preload(:shares)
    |> Repo.get!(id)
  end

  @doc """
  Creates a transaction.
  Transaction belongs to a budget.

  ## Examples

      iex> create_transaction(%{field: value}, 1)
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value}, 1)
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}, budget_id)

  def create_transaction(attrs, budget_id) when is_binary(budget_id) do
    budget_val = budget_id |> Integer.parse(10) |> elem(0)
    create_transaction(attrs, budget_val)
  end

  def create_transaction(attrs, budget_id) do
    attrs = Map.put(attrs, "budget_id", budget_id)
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Ecto.Changeset.change(budget_id: budget_id)
    |> Repo.insert()
  end

  @doc """
  Deletes a Transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{source: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction) do
    Transaction.changeset(transaction, %{})
  end

  alias Siano.Transactions.Share

  @doc """
  Returns the list of shares belonging to a specific transaction which belongs to specific budget.

  ## Examples

      iex> list_shares(1, 3)
      [%Share{}, ...]

  """
  def list_shares(budget_id, transaction_id) do
    Share
    |> join(:inner, [_], t in Transaction, on: ^transaction_id == t.id)
    |> where([_s, t], t.budget_id == ^budget_id)
    |> Repo.all()
  end

  @doc """
  Gets a single share.
  Share belongs to a transaction that in return belongs to a budget.

  Raises `Ecto.NoResultsError` if the Share does not exist.

  ## Examples

      iex> get_share!(123, 1, 3)
      %Share{}

      iex> get_share!(456, 1, 3)
      ** (Ecto.NoResultsError)

  """
  def get_share!(id, budget_id, transaction_id) do
    Share
    |> join(:inner, [_], t in Transaction, on: ^transaction_id == t.id)
    |> where([_s, t], t.budget_id == ^budget_id)
    |> Repo.get!(id)
    end

  @doc """
  Creates a share.
  Share belongs to a transaction that in return belongs to a budget.

  ## Examples

      iex> create_share(%{field: value}, 1, 1)
      {:ok, %Share{}}

      iex> create_share(%{field: bad_value}, 1, 1)
      {:error, %Ecto.Changeset{}}

  """

  def create_share(attrs \\ %{}, budget_id, transaction_id)

  def create_share(attrs, budget_id, transaction_id) when is_binary(budget_id) do
    IO.puts("Function casting budget_id")
    budget_val = budget_id |> Integer.parse(10) |> elem(0)
    create_share(attrs, budget_val, transaction_id)
  end

  def create_share(attrs, budget_id, transaction_id) when is_binary(transaction_id) do
    IO.puts("Function casting transaction_id")
    transaction_val = transaction_id |> Integer.parse(10) |> elem(0)
    create_share(attrs, budget_id, transaction_val)
  end

  def create_share(attrs, budget_id, transaction_id) do
    attrs = Map.put(attrs, "transaction_id", transaction_id)
    %Share{}
    |> Share.changeset(attrs, budget_id)
    |> Ecto.Changeset.change(transaction_id: transaction_id)
    |> Repo.insert()
  end

  @doc """
  Updates a share.
  Share belongs to a transaction that in return belongs to a budget.

  ## Examples

      iex> update_share(share, %{field: new_value})
      {:ok, %Share{}}

      iex> update_share(share, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_share(%Share{} = share, attrs) do
    share
    |> Share.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Share.

  ## Examples

      iex> delete_share(share)
      {:ok, %Share{}}

      iex> delete_share(share)
      {:error, %Ecto.Changeset{}}

  """
  def delete_share(%Share{} = share) do
    Repo.delete(share)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking share changes.

  ## Examples

      iex> change_share(share)
      %Ecto.Changeset{source: %Share{}}

  """
  def change_share(%Share{} = share) do
    Share.changeset(share, %{})
  end
end
