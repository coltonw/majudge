defmodule Majudge.Elections.Ballot do
  use Ecto.Schema
  import Ecto.Changeset
  alias Majudge.Elections.Vote

  schema "ballots" do
    field :candidates, {:array, :map}
    field :name, :string
    has_many :vote, Vote

    timestamps()
  end

  @doc false
  def changeset(ballot, attrs) do
    ballot
    |> cast(attrs, [:name, :candidates])
    |> validate_required([:name, :candidates])
  end
end
