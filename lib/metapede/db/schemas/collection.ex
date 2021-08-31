defmodule Metapede.Db.Schemas.Collection do
  use Metapede.Db.GenCollection,
    collection_name: "collections",
    prefix: "col",
    has_topic: true

  alias Metapede.Db.Schemas.Archive
  alias Metapede.Db.Schemas.Topic

  def load(id) do
    id
    |> get_by_id()
    |> Topic.load_topic()
    |> Map.update("archives", [], &Archive.load_all/1)
  end

  def unload(collection) do
    collection
    |> Topic.unload_topic()
    |> Map.update("archives", [], &Archive.unload_all/1)
    |> upsert()
    |> Map.get("_id")
  end
end
