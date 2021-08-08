defmodule Metapede.Db.Schemas.Project do
  use Metapede.Db.GenCollection, collection_name: "projects"

  alias Metapede.Db.Schemas.Topic
  alias Metapede.Db.Schemas.TimePeriod

  defstruct(
    topic: %{},
    resources: []
  )

  # defp validate(attr), do: attr

  def submit_full(model) do
    model
    |> replace_topic_with_ref()
    |> pull_out_resources()
    |> create()
  end

  defp replace_topic_with_ref(model) do
    res = Topic.upsert(%{page_id: model.topic.page_id}, model.topic)

    model
    |> Map.put_new(:topic_id, res["_id"])
    |> Map.drop([:topic])
  end

  defp pull_out_resources(model) do
    updated_resources =
      model.resources
      |> Enum.map(fn res ->
        res
        |> pair_resource_schema
        |> save_resource
      end)

    model
    |> Map.replace(:resources, updated_resources)
  end

  defp pair_resource_schema(resource) do
    mod =
      %{
        "time_period" => TimePeriod,
        "topic" => Topic
      }
      |> Map.get(resource.res_type)

    {mod, resource}
  end

  defp save_resource({TimePeriod, resource}) do
    res =
      resource.info
      |> TimePeriod.upsert(resource.info)
      |> IO.inspect()

    resource
    |> Map.put_new(:res_id, res["_id"])
    |> Map.drop([:info])
  end

  defp save_resource({Topic, resource}) do
    res =
      resource.info
      |> Topic.upsert(resource.info)
      |> IO.inspect()

    resource
    |> Map.put_new(:res_id, res["_id"])
    |> Map.drop([:info])
  end

  defp save_resource({_schema, resource}), do: resource
end
