defmodule Metapede.Db.Schemas.Archive do
  use Metapede.Db.GenCollection, collection_name: "archives"

  alias Metapede.Db.Schemas.Topic
  # alias Metapede.Db.Schemas.Resource

  defstruct(
    archive_type: "",
    archive_id: nil,
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
    |> pair_id()
    |> unload_schema()
  end

  defp pair_schema(%{archive_type: at} = archive), do: {@res_types[at], archive}

  defp pair_id({schema, %{_id: _id} = archive}), do: {schema, archive}

  defp pair_id({schema, archive}) do
    {schema,
     archive
     |> Map.put(:_id, gen_unique_id(schema))
     |> Map.put(:new, true)}
  end

  defp unload_schema({schema, archive}), do: schema.unload(archive)

  defp gen_unique_id(schema) do
    id = gen_id(schema)
    if(schema.unique_id(id), do: id, else: gen_unique_id(schema))
  end

  defp gen_id(TimePeriod), do: "tpd_" <> gen_id()
  defp gen_id(Event), do: "evt_" <> gen_id()
  defp gen_id(Topic), do: "top_" <> gen_id()
  defp gen_id(), do: UUID.uuid1(:hex)
end
