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
end
