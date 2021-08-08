defmodule Metapede.Db.Schemas.Topic do
  @collection_name "resources.topics"
  use Metapede.Db.GenCollection, collection_name: @collection_name

  defstruct(
    title: nil,
    description: nil,
    page_id: nil,
    thumbnail: nil
  )

  def validate(attr), do: attr

end
