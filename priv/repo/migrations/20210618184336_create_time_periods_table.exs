defmodule Metapede.Repo.Migrations.CreateTimePeriodsTable do
  use Ecto.Migration

  def change do
    create table(:time_periods) do
      add :topic_id, references(:topics)
      add :start_datetime, :naive_datetime
      add :end_datetime, :naive_datetime
      timestamps()
    end
  end
end
