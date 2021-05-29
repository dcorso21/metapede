defmodule Metapede.Repo.Migrations.CreateTopicRelations do
  use Ecto.Migration

  def change do
    create table(:topic_relations) do
      add :topic_id, references(:topics)
      add :relation_id, references(:topics)
      timestamps()
    end

    create index(:topic_relations, [:topic_id])
    create index(:topic_relations, [:relation_id])

    create unique_index(
      :topic_relations,
      [:topic_id, :relation_id],
      name: :topic_relation_index
    )

    create unique_index(
      :topic_relations,
      [:relation_id, :topic_id],
      name: :relation_topic_index
    )
  end

end
