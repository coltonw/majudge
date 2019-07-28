defmodule Majudge.ElectionsTest do
  use Majudge.DataCase

  alias Majudge.Elections

  describe "ballots" do
    alias Majudge.Elections.Ballot

    @valid_attrs %{candidates: [], name: "some name"}
    @update_attrs %{candidates: [], name: "some updated name"}
    @invalid_attrs %{candidates: nil, name: nil}

    def ballot_fixture(attrs \\ %{}) do
      {:ok, ballot} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Elections.create_ballot()

      ballot
    end

    test "list_ballots/0 returns all ballots" do
      ballot = ballot_fixture()
      assert Elections.list_ballots() == [ballot]
    end

    test "get_ballot!/1 returns the ballot with given id" do
      ballot = ballot_fixture()
      assert Elections.get_ballot!(ballot.id) == ballot
    end

    test "create_ballot/1 with valid data creates a ballot" do
      assert {:ok, %Ballot{} = ballot} = Elections.create_ballot(@valid_attrs)
      assert ballot.candidates == []
      assert ballot.name == "some name"
    end

    test "create_ballot/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Elections.create_ballot(@invalid_attrs)
    end

    test "update_ballot/2 with valid data updates the ballot" do
      ballot = ballot_fixture()
      assert {:ok, %Ballot{} = ballot} = Elections.update_ballot(ballot, @update_attrs)
      assert ballot.candidates == []
      assert ballot.name == "some updated name"
    end

    test "update_ballot/2 with invalid data returns error changeset" do
      ballot = ballot_fixture()
      assert {:error, %Ecto.Changeset{}} = Elections.update_ballot(ballot, @invalid_attrs)
      assert ballot == Elections.get_ballot!(ballot.id)
    end

    test "delete_ballot/1 deletes the ballot" do
      ballot = ballot_fixture()
      assert {:ok, %Ballot{}} = Elections.delete_ballot(ballot)
      assert_raise Ecto.NoResultsError, fn -> Elections.get_ballot!(ballot.id) end
    end

    test "change_ballot/1 returns a ballot changeset" do
      ballot = ballot_fixture()
      assert %Ecto.Changeset{} = Elections.change_ballot(ballot)
    end
  end
end
