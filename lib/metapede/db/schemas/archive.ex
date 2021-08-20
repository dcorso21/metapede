defmodule Metapede.Db.Schemas.Archive do
  use Metapede.Db.GenCollection, collection_name: "archives"

  alias Metapede.Db.Schemas.Topic
  alias Metapede.Db.Schemas.Resource

  defstruct(
    topic: %{},
    topic_id: nil,
    resources: []
  )

  def unload(project) do
    project
    |> Topic.unload_topic()
    |> Resource.create_references()
  end

  def load_all(projects), do: Enum.map(projects, &load/1)

  def load(project) do
    project
    |> Map.put("topic", Topic.load(project["topic_id"]))
    |> Map.replace("resources", Resource.load_all(project["resources"]))
  end
end
