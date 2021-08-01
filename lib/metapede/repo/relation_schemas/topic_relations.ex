defmodule Metapede.Relations.TopicRelations do
  use Ecto.Schema
  @attrs [:topic_id, :relation_id]

  schema "topic_relations" do
    field :topic_id, :id
    field :relation_id, :id
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, @attrs)
    |> Ecto.Changeset.unique_constraint(
      [:topic_id, :relation_id],
      name: :topic_relation_index
    )
    |> Ecto.Changeset.unique_constraint(
      [:relation_id, :topic_id],
      name: :relation_topic_index
    )
    |> Ecto.Changeset.foreign_key_constraint(:topic_id)
    |> Ecto.Changeset.foreign_key_constraint(:relation_id)
  end
end
