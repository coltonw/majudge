defmodule Majudge do
  @moduledoc """
  Majudge keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @default_ratings [:excellent, :verygood, :good, :average, :fair, :poor]

  defmodule Candidate do
    @derive {Jason.Encoder, only: [:name, :id, :thumbnail, :value]}
    defstruct name: "Unknown", id: nil, thumbnail: nil, value: [], distance: []
  end

  # to simplify readability, I will be using the symbols:
  # excellent, verygood, good, average, fair, poor

  # Find the number of median votes that must be removed
  # before the rating would change to the given rating.
  # above_cur is the total number of ratings that are
  # higher than the current rating.
  # This function assumes that the median value is equal
  # to or lower than the given rating.
  def _distance_above(rating_votes, total, above_cur) do
    rating_and_above = rating_votes + above_cur

    cond do
      rating_and_above >= total / 2 ->
        {0, rating_and_above}

      true ->
        {total - rating_and_above * 2, rating_and_above}
    end
  end

  # Find the number of median votes that must be removed
  # before the rating would change to the given rating.
  # above_cur is the total number of ratings that are
  # higher than the current rating.
  # This function assumes that the median value is equal
  # to or lower than the given rating.
  def _distance_below(rating_votes, total, below_cur) do
    rating_and_below = rating_votes + below_cur

    cond do
      rating_and_below > total / 2 ->
        {0, rating_and_below}

      true ->
        {total - rating_and_below * 2 + 1, rating_and_below}
    end
  end

  def _distance(
        ratings,
        tallies,
        total,
        distance_helper \\ &_distance_above/3,
        accum_votes \\ 0,
        accum_result \\ []
      )

  def _distance([rating | rest], tallies, total, distance_helper, accum_votes, accum_result) do
    case tallies do
      %{^rating => rating_votes} ->
        {dist, accum_votes} = distance_helper.(rating_votes, total, accum_votes)
        accum_result = accum_result ++ [{rating, dist}]

        if dist == 0 do
          distance_helper = &_distance_below/3
          accum_votes = 0
          ratings_rev = Enum.reverse(rest)
          _distance(ratings_rev, tallies, total, distance_helper, accum_votes, accum_result)
        else
          _distance(rest, tallies, total, distance_helper, accum_votes, accum_result)
        end

      _ ->
        _distance(rest, tallies, total, distance_helper, accum_votes, accum_result)
    end
  end

  def _distance(_, _, _, _, _, accum_result) do
    accum_result
  end

  # find the number of median votes that must be removed for each rating
  def distance(tallies, ratings \\ @default_ratings) do
    total = Enum.sum(Map.values(tallies))

    result = _distance(ratings, tallies, total)
    Enum.sort(result, fn a, b -> elem(a, 1) <= elem(b, 1) end)
  end

  # could easily be converted to a function which creates a compare function from a given list of ratings
  def _compare_rating(a, b) do
    Enum.find_index(@default_ratings, &(&1 == a)) <= Enum.find_index(@default_ratings, &(&1 == b))
  end

  def _compare([], []) do
    true
  end

  def _compare(_, []) do
    true
  end

  def _compare([], _) do
    false
  end

  def _compare([{a_rating, _}], [{b_rating, _}]) do
    _compare_rating(a_rating, b_rating)
  end

  def _compare([{same_rating, _} | a_tail], [{same_rating, _}] = b) do
    _compare(a_tail, b)
  end

  def _compare([{same_rating, _}] = a, [{same_rating, _} | b_tail]) do
    _compare(a, b_tail)
  end

  def _compare([{same_rating, _}, a_next | a_tail] = a, [{same_rating, _}, b_next | b_tail] = b) do
    a_dist = elem(a_next, 1)
    b_dist = elem(b_next, 1)

    cond do
      a_dist < b_dist ->
        _compare([a_next | a_tail], b)

      a_dist > b_dist ->
        _compare(a, [b_next | b_tail])

      a_dist == b_dist ->
        _compare([a_next | a_tail], [b_next | b_tail])
    end
  end

  def _compare([{a_rating, _} | _], [{b_rating, _} | _]) do
    _compare_rating(a_rating, b_rating)
  end

  def sort(distances) do
    Enum.sort(distances, &_compare/2)
  end

  def _compare_candidates(%Candidate{distance: a}, %Candidate{distance: b}) do
    _compare(a, b)
  end

  def sort_candidates(candidates) do
    Enum.sort(candidates, &_compare_candidates/2)
  end

  def count_one(vote, outer_acc) do
    Enum.reduce(vote, outer_acc, fn {candId, rating}, acc ->
      candMap = Map.get(acc, candId, %{})
      curCount = Map.get(candMap, rating, 0)
      Map.put(acc, candId, Map.put(candMap, rating, curCount + 1))
    end)
  end

  def count(votes, acc \\ %{})

  def count(nil, acc) do
    acc
  end

  def count([], acc) do
    acc
  end

  def count([vote | tail], acc) do
    count(tail, count_one(vote, acc))
  end
end
