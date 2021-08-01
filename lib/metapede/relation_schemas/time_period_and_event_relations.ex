defmodule Metapede.Relations.TimePeriodAndEventRelations do
  use Ecto.Schema
  @attrs [:time_period_id, :event_id]

  schema "time_period_and_event_relations" do
    field :time_period_id, :id
    field :event_id, :id
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, @attrs)
    |> Ecto.Changeset.unique_constraint(
      [:time_period_id, :event_id],
      name: :time_period_and_event_index
    )
    |> Ecto.Changeset.foreign_key_constraint(:time_period_id)
    |> Ecto.Changeset.foreign_key_constraint(:event_id)
  end
end
