defmodule Metapede.Db.Schemas.GenericResource do
  alias Metapede.Db.Schemas.Topic

  def load(resource) do
    loaded_topic = Topic.load(resource["topic_id"])

    resource
    |> Map.put(:topic, loaded_topic)
  end
end
