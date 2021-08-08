defmodule Metapede.Db.Schemas.TimePeriod do
  use Metapede.Db.GenCollection, collection_name: "resources.time_periods"
  alias Metapede.Db.Schemas.Topic

  defstruct(
    topic: nil,
    topic_id: nil,
    start_datetime: nil,
    end_datetime: nil,
    sub_time_period_ids: []
  )

  def validate(attr), do: attr

  def extract_and_ref(time_period) do
    updated = Topic.extract_topic(time_period)

    updated
    |> upsert(updated)
    |> Map.get("_id")
  end
end
