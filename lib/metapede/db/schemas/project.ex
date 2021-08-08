defmodule Metapede.Db.Schemas.Project do
  use Metapede.Db.GenCollection, collection_name: "projects"

  alias Metapede.Db.Schemas.Topic
  alias Metapede.Db.Schemas.Resource

  defstruct(
    topic: %{},
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
    res = Topic.upsert(%{page_id: model.topic.page_id}, model.topic)

    model
    |> Map.put_new(:topic_id, res["_id"])
    |> Map.drop([:topic])
  end
end
