defmodule Metapede.Db.Schemas.Project do
  use Metapede.Db.GenCollection, collection_name: "projects"

  alias Metapede.Db.Schemas.Topic

  defstruct(
    topic: %{},
    resources: []
  )

  # defp validate(attr), do: attr

  def submit_full(model) do
    model
    |> replace_topic_with_ref()
  end

  defp replace_topic_with_ref(model) do
    {_stat, _res} = Topic.upsert(%{page_id: model.topic.page_id}, model.topic)

    model
    |> Map.put_new(:topic_id, model.topic.page_id)
    |> Map.drop([:topic])
  end
end
