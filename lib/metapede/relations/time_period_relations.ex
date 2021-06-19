defmodule Metapede.Relations.TimePeriodRelations do
  use Ecto.Schema
  @attrs [:parent_time_period_id, :child_time_period_id]

  schema "time_period_relations" do
    field :parent_time_period_id, :id
    field :child_time_period_id, :id
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, @attrs)
    |> Ecto.Changeset.unique_constraint(
      [:parent_time_period_id, :child_time_period_id],
      name: :time_period_relation_index
    )
    |> Ecto.Changeset.unique_constraint(
      [:child_time_period_id, :parent_time_period_id],
      name: :relation_time_period_index
    )
    |> Ecto.Changeset.foreign_key_constraint(:parent_time_period_id)
    |> Ecto.Changeset.foreign_key_constraint(:child_time_period_id)
  end
end
