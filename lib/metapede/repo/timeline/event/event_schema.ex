defmodule Metapede.Timeline.Event do
  use Ecto.Schema
  alias Metapede.TopicSchema.Topic
  alias Metapede.Timeline.TimePeriodSchema.TimePeriod
  alias Metapede.Relations.TimePeriodAndEventRelations
  @accepted_fields [:datetime]

  schema "events" do
    belongs_to :topic, Topic
    field(:datetime, :string)

    many_to_many(
      :parent_time_periods,
      TimePeriod,
      join_through: TimePeriodAndEventRelations,
      on_delete: :delete_all
    )

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, @accepted_fields)
    # |> Ecto.Changeset.validate_required([:])
    |> Ecto.Changeset.foreign_key_constraint(:events)
    |> Ecto.Changeset.foreign_key_constraint(:parent_time_periods)
  end
end
