defmodule Metapede.Db.Schemas.TimePeriod do
  use Metapede.Db.GenCollection, collection_name: "resources.time_periods"

  defstruct(
      topic: nil,
      start_datetime: nil,
      end_datetime: nil,
      sub_time_period_ids: [],
  )

  def validate(attr), do: attr
end
