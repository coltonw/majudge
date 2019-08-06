defmodule MajudgeWeb.BallotControllerTest do
  use MajudgeWeb.ConnCase

  alias Majudge.Elections

  @create_attrs %{candidates: [], name: "some name"}
  @update_attrs %{candidates: [], name: "some updated name"}
  @invalid_attrs %{candidates: nil, name: nil}

  def fixture(:ballot) do
    {:ok, ballot} = Elections.create_ballot(@create_attrs)
    ballot
  end

  describe "index" do
    test "lists all ballots", %{conn: conn} do
      conn = get(conn, Routes.ballot_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Ballots"
    end
  end

  describe "new ballot" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.ballot_path(conn, :new))
      assert html_response(conn, 200) =~ "New Ballot"
    end
  end

  describe "create ballot" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.ballot_path(conn, :create), ballot: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.ballot_path(conn, :show, id)

      conn = get(conn, Routes.ballot_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Ballot"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.ballot_path(conn, :create), ballot: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Ballot"
    end
  end

  describe "edit ballot" do
    setup [:create_ballot]

    test "renders form for editing chosen ballot", %{conn: conn, ballot: ballot} do
      conn = get(conn, Routes.ballot_path(conn, :edit, ballot))
      assert html_response(conn, 200) =~ "Edit Ballot"
    end
  end

  describe "update ballot" do
    setup [:create_ballot]

    test "redirects when data is valid", %{conn: conn, ballot: ballot} do
      conn = put(conn, Routes.ballot_path(conn, :update, ballot), ballot: @update_attrs)
      assert redirected_to(conn) == Routes.ballot_path(conn, :show, ballot)

      conn = get(conn, Routes.ballot_path(conn, :show, ballot))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, ballot: ballot} do
      conn = put(conn, Routes.ballot_path(conn, :update, ballot), ballot: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Ballot"
    end
  end

  describe "delete ballot" do
    setup [:create_ballot]

    test "deletes chosen ballot", %{conn: conn, ballot: ballot} do
      conn = delete(conn, Routes.ballot_path(conn, :delete, ballot))
      assert redirected_to(conn) == Routes.ballot_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.ballot_path(conn, :show, ballot))
      end
    end
  end

  defp create_ballot(_) do
    ballot = fixture(:ballot)
    {:ok, ballot: ballot}
  end
end
