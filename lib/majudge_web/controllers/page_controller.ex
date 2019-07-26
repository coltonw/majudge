defmodule MajudgeWeb.PageController do
  use MajudgeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
