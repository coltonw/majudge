defmodule MajudgeWeb.BallotController do
  require Logger

  use MajudgeWeb, :controller

  alias Majudge.Elections
  alias Majudge.Elections.Ballot

  def _candidates_decode(%{"candidates" => nil} = ballot_params) do
    ballot_params
  end

  def _candidates_decode(%{"candidates" => candidates} = ballot_params) do
    Map.put(ballot_params, "candidates", Enum.map(candidates, &Jason.decode!(&1)))
  end

  def _candidates_decode(ballot_params) do
    ballot_params
  end

  # this assumes you have a struct which came from ecto
  def _candidates_encode(ballot) do
    %{ballot | candidates: Enum.map(ballot.candidates, &Jason.encode!(&1))}
  end

  def index(conn, _params) do
    ballots = Elections.list_ballots()
    ballots = Enum.map(ballots, &_candidates_encode/1)
    render(conn, "index.html", ballots: ballots)
  end

  def new(conn, _params) do
    changeset = Elections.change_ballot(%Ballot{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"ballot" => ballot_params}) do
    ballot_params = _candidates_decode(ballot_params)

    case Elections.create_ballot(ballot_params) do
      {:ok, ballot} ->
        conn
        |> put_flash(:info, "Ballot created successfully.")
        |> redirect(to: Routes.ballot_path(conn, :show, ballot))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    ballot = Elections.get_ballot!(id)
    ballot = _candidates_encode(ballot)
    render(conn, "show.html", ballot: ballot)
  end

  def edit(conn, %{"id" => id}) do
    ballot = Elections.get_ballot!(id)
    ballot = _candidates_encode(ballot)
    changeset = Elections.change_ballot(ballot)
    render(conn, "edit.html", ballot: ballot, changeset: changeset)
  end

  def update(conn, %{"id" => id, "ballot" => ballot_params}) do
    ballot = Elections.get_ballot!(id)

    case Elections.update_ballot(ballot, _candidates_decode(ballot_params)) do
      {:ok, ballot} ->
        conn
        |> put_flash(:info, "Ballot updated successfully.")
        |> redirect(to: Routes.ballot_path(conn, :show, _candidates_encode(ballot)))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", ballot: _candidates_encode(ballot), changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    ballot = Elections.get_ballot!(id)
    {:ok, _ballot} = Elections.delete_ballot(ballot)

    conn
    |> put_flash(:info, "Ballot deleted successfully.")
    |> redirect(to: Routes.ballot_path(conn, :index))
  end
end
