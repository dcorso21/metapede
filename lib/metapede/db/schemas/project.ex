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
    res = Topic.extract_to_ref(model.topic)
    Resource.save_reference({res, model}, :topic_id, :topic)
  end
end
