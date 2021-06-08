defmodule Metapede.Collection.Topic do
  use Ecto.Schema

  alias Metapede.Collection.Topic
  alias Metapede.Relations.TopicRelations

  schema "topics" do
    field :title, :string
    field :description, :string
    field :thumbnail, :string
    field :page_id, :integer

    many_to_many :sub_topics,
                 Topic,
                 join_through: TopicRelations,
                 join_keys: [topic_id: :id, relation_id: :id],
                 on_delete: :delete_all

    many_to_many :parent_topics,
                 Topic,
                 join_through: TopicRelations,
                 join_keys: [relation_id: :id, topic_id: :id],
                 on_delete: :delete_all

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:title, :description])
    |> Ecto.Changeset.validate_required([:title, :description])
    |> Ecto.Changeset.foreign_key_constraint(:sub_topics)
    |> Ecto.Changeset.foreign_key_constraint(:parent_topics)
  end
end
