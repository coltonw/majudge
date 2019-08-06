defmodule MajudgeWeb.TallyController do
  require Logger
  use MajudgeWeb, :controller

  alias Majudge.Elections

  def index(conn, _params) do
    ballot = Elections.get_current_ballot_votes!()
    Logger.warn(ballot.votes)
    render(conn, "index.html", ballot: ballot)
  end
end
