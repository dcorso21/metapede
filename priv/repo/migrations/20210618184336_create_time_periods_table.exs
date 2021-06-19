defmodule Metapede.Repo.Migrations.CreateTimePeriodsTable do
  use Ecto.Migration

  def change do
    create table(:time_periods) do
      timestamps()
    end
  end
end
