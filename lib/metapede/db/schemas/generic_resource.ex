defmodule Metapede.Db.Schemas.GenericResource do
  alias Metapede.Db.Schemas.Topic

  def load(_id, %{"info" => %{"topic_id" => topic_id}} = resource) do
    loaded_topic = Topic.load(topic_id, resource)
    info = Map.put(resource["info"], "topic", loaded_topic)
    Map.replace(resource, "info", info)
  end
  def load(_id, resource), do: resource
end
