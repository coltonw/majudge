defmodule Majudge.Repo.Migrations.CreateVotes do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :name, :string
      add :email, :string
      add :vote, :map
      add :ballot_id, references(:ballots, on_delete: :delete_all),
                      null: false

      timestamps()
    end

    create index(:votes, [:ballot_id])
    create unique_index(:votes, [:email, :ballot_id], name: :vote_idx)
  end
end
