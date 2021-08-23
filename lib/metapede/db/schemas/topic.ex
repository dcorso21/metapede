defmodule Metapede.Db.Schemas.Topic do
  @collection_name "topics"
  use Metapede.Db.GenCollection, collection_name: @collection_name, prefix: "tpc"
  alias Metapede.Db.Schemas.Resource
  alias Metapede.WikiConnect

  defstruct(
    title: nil,
    description: nil,
    page_id: nil,
    thumbnail: nil
  )

  def load_topic(parent), do: Map.put(parent, "topic", load(parent["topic_id"]))

  def unload_topic(%{"topic_seed" => term} = parent) do
    parent
    |> Map.drop(["topic_seed"])
    |> Map.put("topic", seed_topic_with_term(term))
    |> unload_topic()
  end

  def unload_topic(parent),
    do: Resource.save_reference({unload(parent["topic"]), parent}, "topic_id", "topic")

  defp transform_wiki_data(data) do
    data
    |> Map.take(["title", "description", "thumbnail"])
    |> Map.put("page_id", data["pageid"])
    |> Map.put("thumbnail", pull_thumb_url(data))
  end

  defp seed_topic_with_term(term) do
    term
    |> WikiConnect.search_by_term()
    |> Enum.at(0)
    |> transform_wiki_data()
  end

  defp pull_thumb_url(%{"thumbnail" => details}), do: details["source"]
  defp pull_thumb_url(_), do: nil
end
