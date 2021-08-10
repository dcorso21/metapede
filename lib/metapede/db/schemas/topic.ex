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

  # def extract_topic(%{topic: nil} = parent), do: parent
  def extract_topic(parent) do
    id = unload(parent.topic)
    Resource.save_reference({id, parent}, :topic_id, :topic)
  end

end
