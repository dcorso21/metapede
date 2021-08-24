defmodule Metapede.Db.Schemas.Archive do
  use Metapede.Db.GenCollection,
    collection_name: "archives",
    prefix: "arc",
    has_topic: false

  alias Metapede.Db.Schemas.Topic
  alias Metapede.Db.Schemas.TimePeriod
  alias Metapede.Db.Schemas.Event

  defstruct(
    resource_type: "",
    resource_id: nil,
    data: %{}
  )

  @res_types %{
    "time_period" => TimePeriod,
    "topic" => Topic,
    "event" => Event
  }

  def load(archive) do
    archive
    |> pair_schema()
    |> load_schema()
  end

  def unload(archive) do
    archive
    |> pair_schema()
    |> unload_schema()
  end

  defp pair_schema(%{"resource_type" => type} = archive), do: {@res_types[type], archive}

  defp unload_schema({schema, archive}) do
    id = schema.unload(archive["data"])

    archive
    |> Map.put("resource_id", id)
    |> Map.drop(["data"])
  end

  defp load_schema({schema, archive}) do
    Map.put(archive, "data", schema.load(archive["resource_id"]))
  end
end
