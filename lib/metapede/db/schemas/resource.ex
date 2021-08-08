defmodule Metapede.Db.Schemas.Resource do
  alias Metapede.Db.Schemas.Topic
  alias Metapede.Db.Schemas.TimePeriod

  defstruct(
    res_id: nil,
    res_type: nil,
    info: nil
  )

  #   defp validate(attr), do: attr
  def create_references(model) do
    updated_resources =
      model.resources
      |> Enum.map(fn res ->
        res
        |> pair_resource_schema
        |> save_resource
        |> save_reference
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

  defp save_resource({nil, resource}), do: resource
  defp save_resource({schema, resource}), do: {schema.extract_to_ref(resource), resource}

  defp save_reference({document, resource}) do
    resource
    |> Map.put_new(:res_id, document["_id"])
    |> Map.drop([:info])
  end
end
