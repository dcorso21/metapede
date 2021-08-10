defmodule Metapede.Db.Schemas.Topic do
  @collection_name "resources.topics"
  use Metapede.Db.GenCollection, collection_name: @collection_name
  alias Metapede.Db.Schemas.Resource

  defstruct(
    title: nil,
    description: nil,
    page_id: nil,
    thumbnail: nil
  )

  # def validate(attr), do: attr

  def unload_topic(parent) do
    id = unload(parent.topic)
    Resource.save_reference({id, parent}, :topic_id, :topic)
  end

  def load_topic(parent) do
    topic = load(parent["topic_id"])
    Map.put(parent, "topic", topic)
  end

end
