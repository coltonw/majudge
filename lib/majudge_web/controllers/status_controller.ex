defmodule MajudgeWeb.StatusController do
  require Logger
  use MajudgeWeb, :controller

  def index(conn, _params) do
    json(conn, %{status: "good"})
  end
end
