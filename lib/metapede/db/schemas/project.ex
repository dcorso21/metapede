defmodule Metapede.Db.Schemas.Project do
  use Metapede.Db.GenCrud, collection_name: "projects"

  defstruct Project: [:title, :description, :resources]

  def validate(attr), do: attr
end
