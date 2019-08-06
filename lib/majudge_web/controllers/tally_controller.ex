defmodule MajudgeWeb.TallyController do
  require Logger
  use MajudgeWeb, :controller

  alias Majudge.Elections
  alias Majudge.Candidate

  def count_to_candidate({name, count}) do
    count =
      for {rating, rating_count} <- count, into: %{} do
        {String.to_existing_atom(rating), rating_count}
      end

    %Candidate{name: name, distance: Majudge.distance(count), value: count}
  end

  def index(conn, _params) do
    ballot = Elections.get_current_ballot_votes!()

    tally =
      ballot.vote
      |> Enum.map(& &1.vote)
      |> Majudge.count()
      |> Enum.map(&count_to_candidate/1)
      |> Majudge.sort_candidates()

    render(conn, "index.html", tally: tally)
  end
end
