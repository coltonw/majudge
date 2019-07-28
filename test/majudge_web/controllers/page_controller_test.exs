defmodule MajudgeWeb.PageControllerTest do
  use MajudgeWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Majority Judgement"
  end
end
