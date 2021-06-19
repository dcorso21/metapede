defmodule Metapede.Repo.Migrations.CreateTimePeriodsTable do
  use Ecto.Migration

  def change do
    create table(:time_periods) do
      add :topic_id, references(:topics)
      add :start_datetime, :string
      add :end_datetime, :string
      timestamps()
    end
  end
end
