defmodule MajudgeTest do
  use ExUnit.Case
  doctest Majudge

  test "comparing ratings" do
    assert Majudge._compare_rating(:excellent, :fair)
    assert not Majudge._compare_rating(:fair, :excellent)
    assert not Majudge._compare_rating(:poor, :excellent)
    assert not Majudge._compare_rating(:poor, :good)
    assert Majudge._compare_rating(:fair, :fair)
    assert Majudge._compare_rating(:fair, :poor)

    assert Enum.sort([:good, :verygood, :poor, :excellent, :fair], &Majudge._compare_rating/2) ==
             [:excellent, :verygood, :good, :fair, :poor]
  end

  test "comparing distances" do
    assert Majudge._compare([excellent: 0, good: 3], good: 0, excellent: 3)
    assert not Majudge._compare([good: 0, excellent: 3], excellent: 0, good: 3)
    assert Majudge._compare([fair: 0, good: 3], fair: 0, good: 4)
    assert not Majudge._compare([fair: 0, good: 4], fair: 0, good: 3)
    assert not Majudge._compare([good: 0, poor: 3], good: 0, fair: 5)
    assert Majudge._compare([good: 0, verygood: 3], good: 0, poor: 3)
    assert not Majudge._compare([good: 0, poor: 3], good: 0, verygood: 3)
    assert Majudge._compare([good: 0], good: 0)
    assert Majudge._compare([good: 0], poor: 0)
    assert Majudge._compare([poor: 0], [])
    assert not Majudge._compare([], poor: 0)
    assert not Majudge._compare([fair: 0, average: 3, poor: 10], fair: 0, average: 3, poor: 11)

    assert not Majudge._compare([fair: 0, average: 3, good: 7, poor: 10],
             fair: 0,
             average: 3,
             good: 7,
             poor: 11
           )
  end

  test "sorting a list of distances" do
    assert Majudge.sort([
             [fair: 0, average: 3, good: 7, poor: 10],
             [excellent: 0, verygood: 6],
             [good: 0, verygood: 1],
             [fair: 0, average: 3, good: 7, poor: 9]
           ]) == [
             [excellent: 0, verygood: 6],
             [good: 0, verygood: 1],
             [fair: 0, average: 3, good: 7, poor: 10],
             [fair: 0, average: 3, good: 7, poor: 9]
           ]
  end

  test "sorting a list of candidates" do
    alias Majudge.Candidate

    assert Majudge.sort_candidates([
             %Candidate{name: "Abe", distance: [fair: 0, average: 3, good: 7, poor: 10]},
             %Candidate{name: "Beth", distance: [excellent: 0, verygood: 6]},
             %Candidate{name: "Caleb", distance: [good: 0, verygood: 1]},
             %Candidate{name: "Dino", distance: [fair: 0, average: 3, good: 7, poor: 9]}
           ]) == [
             %Candidate{name: "Beth", distance: [excellent: 0, verygood: 6]},
             %Candidate{name: "Caleb", distance: [good: 0, verygood: 1]},
             %Candidate{name: "Abe", distance: [fair: 0, average: 3, good: 7, poor: 10]},
             %Candidate{name: "Dino", distance: [fair: 0, average: 3, good: 7, poor: 9]}
           ]
  end

  test "counting up some votes" do
    assert Majudge.count([%{"1" => :excellent, "2" => :poor}]) == %{
             "1" => %{excellent: 1},
             "2" => %{poor: 1}
           }

    assert Majudge.count([
             %{"1" => :excellent, "2" => :poor},
             %{"1" => :excellent, "2" => :verygood}
           ]) == %{
             "1" => %{excellent: 2},
             "2" => %{poor: 1, verygood: 1}
           }
  end
end
