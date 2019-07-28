defmodule MajudgeWeb.VoteView do
  use MajudgeWeb, :view

  def ballot_options(ballots) do
    ballots |> Enum.map(fn b -> {b.name, b.id} end)
  end
end
