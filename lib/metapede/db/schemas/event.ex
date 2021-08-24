defmodule Metapede.Db.Schemas.Event do
  use Metapede.Db.GenCollection, collection_name: "events", prefix: "evt", has_topic: true

  defstruct(
    topic: nil,
    topic_id: nil,
    datetime: nil,
  )
end
