defmodule Metapede.Db.Schemas.Project do
  use Metapede.Db.GenCollection, collection_name: "projects"

  alias Metapede.Db.Schemas.Topic
  alias Metapede.Db.Schemas.Resource

  defstruct(
    topic: %{},
    topic_id: nil,
    resources: []
  )

  # defp validate(attr), do: attr

  def submit_full(model) do
    model
    |> Topic.extract_topic()
    |> IO.inspect()
    |> Resource.create_references()
    |> create()
  end

  def load_all(projects), do: Enum.map(projects, &load/1)

  def load(project) do
    project
    |> Map.put("topic", Topic.load(project["topic_id"]))
    |> Map.replace("resources", Resource.load_all(project["resources"]))
  end
end
