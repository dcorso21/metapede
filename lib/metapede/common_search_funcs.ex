defmodule Metapede.CommonSearchFuncs do
  alias MetapedeWeb.Controllers.Transforms.WikiTransforms
  alias Metapede.Collection.Topic
  alias Metapede.Collection
  alias Metapede.Repo

  def decode_and_format_topic(topic) do
    formatted =
      Poison.decode!(topic)
      |> WikiTransforms.transform_wiki_data()

    existing_ids = Collection.check_for_page_id(formatted["page_id"])
    get_topic_info(formatted, existing_ids)
  end

  def add_association(new_assoc, parent_object, atom_name, assoc_func) do
    parent_object
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(atom_name, assoc_func.(new_assoc))
    |> Repo.update!()
  end

  defp get_topic_info(_params, [id]), do: {:existing, Collection.get_topic!(id)}
  defp get_topic_info(params, []), do: {:new, Topic.changeset(%Topic{}, params)}
end
