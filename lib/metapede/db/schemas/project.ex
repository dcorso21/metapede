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
    |> create_topic_reference()
    |> Resource.create_references()
    |> create()
  end

  defp create_topic_reference(model) do
    id = Topic.extract_and_ref(model.topic)
    Resource.save_reference({id, model}, :topic_id, :topic)
  end


  def load_all(projects), do: Enum.map(projects, &load/1)
  def load(project) do
    topic = Topic.get_by_id(project.topic_id)
    resources = Resource.load_all(project.resources)

    project
    |> Map.put(:topic, topic)
    |> Map.replace(:resources, resources)
  end
end
