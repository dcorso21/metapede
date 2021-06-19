defmodule Metapede.Repo.Migrations.CreateTimePeriodAndEventRelations do
  use Ecto.Migration

  def change do
    create table(:time_period_and_event_relations) do
      add :time_period_id, references(:time_periods, on_delete: :delete_all)
      add :event_id, references(:events, on_delete: :delete_all)
      timestamps()
    end

    create index(:time_period_and_event_relations, [:time_period_id])
    create index(:time_period_and_event_relations, [:event_id])

    create unique_index(
      :time_period_and_event_relations,
      [:time_period_id, :event_id],
      name: :time_period_and_event_relation_index
    )
  end

end
