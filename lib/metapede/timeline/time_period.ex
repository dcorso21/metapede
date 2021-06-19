defmodule Metapede.Timeline.TimePeriod do
  use Ecto.Schema
  alias Metapede.Collection.Topic
  alias Metapede.Timeline.Event

  schema "time_periods" do

    has_one :topic_info, Topic

    many_to_many(
      :events,
      Event,
      join_through: TimePeriodAndEventRelations,
      join_keys: [parent_id: :id, child_id: :id],
      on_delete: :delete_all
    )

    many_to_many(
      :sub_time_periods,
      TimePeriods,
      join_through: TimePeriodRelations,
      join_keys: [parent_id: :id, child_id: :id],
      on_delete: :delete_all
    )

    many_to_many(
      :parent_time_periods,
      TimePeriods,
      join_through: TimePeriodRelations,
      join_keys: [child_id: :id, parent_id: :id],
      on_delete: :delete_all
    )

    timestamps()
  end
end
