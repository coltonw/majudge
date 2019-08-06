defmodule Majudge.Repo.Migrations.CreateBallots do
  use Ecto.Migration

  def change do
    create table(:ballots) do
      add :name, :string
      add :candidates, {:array, :map}

      timestamps()
    end
  end
end
