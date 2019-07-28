defmodule Majudge.Elections.Ballot do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ballots" do
    field :candidates, {:array, :map}
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(ballot, attrs) do
    ballot
    |> cast(attrs, [:name, :candidates])
    |> validate_required([:name, :candidates])
  end
end
