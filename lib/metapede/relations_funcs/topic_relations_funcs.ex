defmodule Metapede.TopicRelationsFuncs do
  @moduledoc """
  The Collection context.
  """

  import Ecto.Query, warn: false
  alias Metapede.Repo
  alias Metapede.Relations.TopicRelations

  def create_relation(topic_id, relation_id) do
    entry = %TopicRelations{
      topic_id: topic_id,
      relation_id: relation_id
    }
    Repo.insert!(entry)
  end

  def list_relations do
    Repo.all(TopicRelations)
  end
end
