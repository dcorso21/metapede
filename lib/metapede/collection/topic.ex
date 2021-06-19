defmodule Metapede.Collection.Topic do
  use Ecto.Schema

  alias Metapede.Relations.TopicRelations
  alias Metapede.Collection.Topic
  alias Metapede.Timeline.{Event, TimePeriod}

  @accepted_fields [
    :title,
    :description,
    :thumbnail,
    :page_id
  ]

  schema "topics" do
    field(:title, :string)
    field(:description, :string)
    field(:thumbnail, :string)
    field(:page_id, :integer)

    belongs_to :event, Event

    belongs_to :time_period, TimePeriod

    many_to_many(
      :sub_topics,
      Topic,
      join_through: TopicRelations,
      join_keys: [topic_id: :id, relation_id: :id],
      on_delete: :delete_all
    )

    many_to_many(
      :parent_topics,
      Topic,
      join_through: TopicRelations,
      join_keys: [relation_id: :id, topic_id: :id],
      on_delete: :delete_all
    )

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, @accepted_fields)
    |> Ecto.Changeset.validate_required([:title])
    |> Ecto.Changeset.foreign_key_constraint(:sub_topics)
    |> Ecto.Changeset.foreign_key_constraint(:parent_topics)
  end
end
