defmodule Metapede.CommonSearchFuncs do
  alias MetapedeWeb.Controllers.Transforms.WikiTransforms
  alias Metapede.Collection.Topic
  alias Metapede.Collection
  alias Metapede.Repo

  @doc """
  Takes the wiki selection, decodes it, formats it to desired struct.
  Then, checks to see if this topic exists already by querying for the page_id
  Finally, returns the status with the topic

  example: {:ok, new_topic}
  """
  def decode_and_format_topic(topic) do
    topic
    |> Poison.decode!
    |> WikiTransforms.transform_wiki_data
    |> Collection.check_for_page_id
    |> get_topic_info
  end

  defp get_topic_info({_params, [id]}), do: {:existing, Collection.get_topic!(id)}
  defp get_topic_info({params, []}), do: {:new, Topic.changeset(%Topic{}, params)}

  def add_association(new_assoc, parent_object, atom_name, assoc_func) do
    parent_object
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(atom_name, assoc_func.(new_assoc))
    |> Repo.update!()
  end

  def check_for_existing_time_period({:existing, topic}) do
    case Repo.preload(topic, [:time_period]) do
      %Topic{time_period: nil} ->
        {:existing, topic}

      %Topic{time_period: _found} ->
        {:has_time_period, topic}
    end
  end

  def check_for_existing_time_period(any), do: any

  def create_if_new({:new, new_topic}), do: Collection.create_topic_from_struct(new_topic)
  def create_if_new({:existing, topic}), do: {:existing, topic}
end
