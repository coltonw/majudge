defmodule MajudgeWeb.VoteController do
  require Logger

  use MajudgeWeb, :controller

  alias Majudge.Elections
  alias Majudge.Elections.Vote

  def _vote_decode(%{"vote" => nil} = vote_params) do
    vote_params
  end

  def _vote_decode(%{"vote" => vote} = vote_params) do
    Map.put(vote_params, "vote", Jason.decode!(vote))
  end

  def _vote_decode(vote_params) do
    vote_params
  end

  def index(conn, _params) do
    votes = Elections.list_votes()
    render(conn, "index.html", votes: votes)
  end

  def new(conn, _params) do
    changeset = Elections.change_vote(%Vote{})
    ballot = Elections.get_current_ballot!()
    render(conn, "new.html", changeset: changeset, ballot: ballot)
  end

  def create(conn, %{"vote" => vote_params}) do
    vote_params = _vote_decode(vote_params)
    case Elections.create_vote(vote_params) do
      {:ok, vote} ->
        conn
        |> put_flash(:info, "Vote created successfully.")
        |> redirect(to: Routes.vote_path(conn, :show, vote))

      {:error, %Ecto.Changeset{} = changeset} ->
        ballot = Elections.get_current_ballot!()
        render(conn, "new.html", changeset: changeset, ballot: ballot)
    end
  end

  def show(conn, %{"id" => id}) do
    vote = Elections.get_vote!(id)
    render(conn, "show.html", vote: vote)
  end

  def edit(conn, %{"id" => id}) do
    vote = Elections.get_vote!(id)
    changeset = Elections.change_vote(vote)
    ballot = Elections.get_ballot!(vote.ballot_id)
    render(conn, "edit.html", vote: vote, changeset: changeset, ballot: ballot)
  end

  def update(conn, %{"id" => id, "vote" => vote_params}) do
    vote_params = _vote_decode(vote_params)
    vote = Elections.get_vote!(id)

    case Elections.update_vote(vote, vote_params) do
      {:ok, vote} ->
        conn
        |> put_flash(:info, "Vote updated successfully.")
        |> redirect(to: Routes.vote_path(conn, :show, vote))

      {:error, %Ecto.Changeset{} = changeset} ->
        ballot = Elections.get_ballot!(vote.ballot_id)
        render(conn, "edit.html", vote: vote, changeset: changeset, ballot: ballot)
    end
  end

  def delete(conn, %{"id" => id}) do
    vote = Elections.get_vote!(id)
    {:ok, _vote} = Elections.delete_vote(vote)

    conn
    |> put_flash(:info, "Vote deleted successfully.")
    |> redirect(to: Routes.vote_path(conn, :index))
  end
end
