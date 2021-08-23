defmodule Metapede.Db.Schemas.Archive do
  use Metapede.Db.GenCollection, collection_name: "archives", prefix: "arc"
  alias Metapede.Db.Schemas.Topic
  alias Metapede.Db.Schemas.TimePeriod

  defstruct(
    resource_type: "",
    resource_id: nil,
    data: %{}
  )

  @res_types %{
    "time_period" => TimePeriod,
    "topic" => Topic,
    "event" => GenericResource
  }

  def load_all(archives), do: Enum.map(archives, &load/1)

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

  defp pair_schema(%{"resource_type" => at} = archive), do: {@res_types[at], archive}

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
