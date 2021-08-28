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

  @res_prefixes %{
    "tpd" => "time_period",
    "tpc" => "topic",
    "evt" => "event"
  }

  @res_schemas %{
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

  defp pair_schema(%{"resource_type" => type} = archive), do: {@res_schemas[type], archive}

  defp unload_schema({schema, archive}) do
    id = schema.unload(archive["data"])

    archive
    |> Map.put("resource_id", id)
    |> Map.drop(["data"])
  end

  defp load_schema({schema, archive}) do
    Map.put(archive, "data", schema.load(archive["resource_id"]))
  end

  def get_res_name_and_schema(resource_id) do
    prefix =
      resource_id
      |> String.split("_")
      |> Enum.at(0)

    IO.inspect(prefix, label: "prefix")
    name = @res_prefixes[prefix]
    {name, @res_schemas[name]}
  end
end
