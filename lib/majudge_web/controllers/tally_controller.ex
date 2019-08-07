defmodule MajudgeWeb.TallyController do
  require Logger
  use MajudgeWeb, :controller

  alias Majudge.Elections
  alias Majudge.Candidate

  def count_to_candidate({id, count}, candMap) do
    count =
      for {rating, rating_count} <- count, into: %{} do
        {String.to_existing_atom(rating), rating_count}
      end

    name = candMap[id]["name"]
    thumbnail = candMap[id]["thumbnail"]

    %Candidate{
      id: id,
      name: name,
      thumbnail: thumbnail,
      distance: Majudge.distance(count),
      value: count
    }
  end

  def index(conn, _params) do
    ballot = Elections.get_current_ballot_votes!()

    candMap = for candidate <- ballot.candidates, into: %{}, do: {candidate["id"], candidate}

    tally =
      ballot.vote
      |> Enum.map(& &1.vote)
      |> Majudge.count()
      |> Enum.map(&count_to_candidate(&1, candMap))
      |> Majudge.sort_candidates()

    render(conn, "index.html", tally: tally)
  end
end
