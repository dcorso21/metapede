defmodule Metapede.Repo.Migrations.CreateTimePeriodsTable do
  use Ecto.Migration

  def change do
    create table(:time_periods) do
      add :topic_id, references(:topic)
      timestamps()
    end
  end
end
