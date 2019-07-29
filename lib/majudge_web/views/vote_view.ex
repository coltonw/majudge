defmodule MajudgeWeb.VoteView do
  use MajudgeWeb, :view

  def ballot_options(ballots) do
    ballots |> Enum.map(fn b -> {b.name, b.id} end)
  end

  def ratings() do
    [
      excellent: "Extremely Interested",
      verygood: "Very Interested",
      good: "Interested",
      average: "Ambivalent",
      fair: "Uninterested",
      poor: "Extremely Uninterested"
    ]
  end
end
