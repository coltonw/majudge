defmodule Majudge.Elections do
  @moduledoc """
  The Elections context.
  """

  import Ecto.Query, warn: false
  alias Majudge.Repo

  alias Majudge.Elections.Ballot

  @doc """
  Returns the list of ballots.

  ## Examples

      iex> list_ballots()
      [%Ballot{}, ...]

  """
  def list_ballots do
    Repo.all(Ballot)
  end

  @doc """
  Gets a single ballot.

  Raises `Ecto.NoResultsError` if the Ballot does not exist.

  ## Examples

      iex> get_ballot!(123)
      %Ballot{}

      iex> get_ballot!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ballot!(id), do: Repo.get!(Ballot, id)

  @doc """
  Creates a ballot.

  ## Examples

      iex> create_ballot(%{field: value})
      {:ok, %Ballot{}}

      iex> create_ballot(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ballot(attrs \\ %{}) do
    %Ballot{}
    |> Ballot.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ballot.

  ## Examples

      iex> update_ballot(ballot, %{field: new_value})
      {:ok, %Ballot{}}

      iex> update_ballot(ballot, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ballot(%Ballot{} = ballot, attrs) do
    ballot
    |> Ballot.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Ballot.

  ## Examples

      iex> delete_ballot(ballot)
      {:ok, %Ballot{}}

      iex> delete_ballot(ballot)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ballot(%Ballot{} = ballot) do
    Repo.delete(ballot)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ballot changes.

  ## Examples

      iex> change_ballot(ballot)
      %Ecto.Changeset{source: %Ballot{}}

  """
  def change_ballot(%Ballot{} = ballot) do
    Ballot.changeset(ballot, %{})
  end
end
