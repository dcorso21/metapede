defmodule Metapede.Db.Schemas.Resource do
  use Metapede.Db.GenCrud, collection_name: "resources"

  defstruct Resource: [:res_type, :res_id]

  def validate(attr), do: attr
end
