defmodule Majudge.Elections.Vote do
  use Ecto.Schema
  import Ecto.Changeset
  alias Majudge.Elections.Ballot

  schema "votes" do
    field :email, :string
    field :name, :string
    field :vote, :map
    belongs_to :ballot, Ballot

    timestamps()
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:name, :email, :vote, :ballot_id])
    |> validate_required([:name, :email, :vote, :ballot_id])
  end
end
