defmodule Metapede.Timeline.TimePeriod do
  use Ecto.Schema
  alias Metapede.Collection.Topic
  alias Metapede.Timeline.{Event, TimePeriod}
  alias Metapede.Relations.{TimePeriodAndEventRelations, TimePeriodRelations}

  schema "time_periods" do
    belongs_to :topic, Topic

    many_to_many(
      :events,
      Event,
      join_through: TimePeriodAndEventRelations,
      join_keys: [parent_id: :id, child_id: :id],
      on_delete: :delete_all
    )

    many_to_many(
      :sub_time_periods,
      TimePeriod,
      join_through: TimePeriodRelations,
      join_keys: [parent_time_period_id: :id, child_time_period_id: :id],
      on_delete: :delete_all
    )

    many_to_many(
      :parent_time_periods,
      TimePeriod,
      join_through: TimePeriodRelations,
      join_keys: [child_time_period_id: :id, parent_time_period_id: :id],
      on_delete: :delete_all
    )

    timestamps()
  end
end
