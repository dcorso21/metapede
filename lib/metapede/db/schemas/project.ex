defmodule Metapede.Db.Schemas.Project do
  use Metapede.Db.GenCollection, collection_name: "projects"

  defstruct(
    title: nil,
    description: nil
  )

  def validate(attr), do: attr
end
