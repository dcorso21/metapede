defmodule Metapede.Collection.Topic do
  use Ecto.Schema

  alias Metapede.Collection.Topic
  alias Metapede.Relations.TopicRelations

  schema "topics" do
    field :name, :string
    field :description, :string

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
    |> Ecto.Changeset.cast(params, [:name, :description])
    |> Ecto.Changeset.validate_required([:name, :description])
    |> Ecto.Changeset.foreign_key_constraint(:sub_topics)
    |> Ecto.Changeset.foreign_key_constraint(:parent_topics)
  end
end

"""
alias Metapede.Collection.Topic
alias Metapede.Repo
alias Metapede.Relations.TopicRelations

davey = %Topic{
  name: "davey",
  description: "this description"
}

andreia = %Topic{
  name: "new",
  description: "ayooo",
  sub_topics: [d]
}
"""
