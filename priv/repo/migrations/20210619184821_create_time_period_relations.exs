defmodule Metapede.Repo.Migrations.CreateTimePeriodRelations do
  use Ecto.Migration

  def change do
    create table(:time_period_relations) do
      add(:parent_time_period_id, references(:time_periods, on_delete: :delete_all))
      add(:child_time_period_id, references(:time_periods, on_delete: :delete_all))
      timestamps()
    end

    create(index(:time_period_relations, [:parent_time_period_id]))
    create(index(:time_period_relations, [:child_time_period_id]))

    create unique_index(
      :time_period_relations,
      [:parent_time_period_id, :child_time_period_id],
      name: :parent_child_index
    )

    create unique_index(
      :time_period_relations,
      [:child_time_period_id, :parent_time_period_id],
      name: :child_parent_index
    )
  end
end
