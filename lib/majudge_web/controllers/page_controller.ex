defmodule MajudgeWeb.PageController do
  use MajudgeWeb, :controller

  def index(conn, _params) do
    Majudge.SleepRDS.start_db()
    render(conn, "index.html")
  end
end
