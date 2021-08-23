defmodule Metapede.CommonSearchFuncs do
  alias Metapede.TopicSchema.Topic
  alias Metapede.TopicSchema.TopicContext
  alias Metapede.Repo

  @doc """
  Takes the wiki selection, decodes it, formats it to desired struct.
  Then, checks to see if this topic exists already by querying for the page_id
  Finally, returns the status with the topic

  example: {:ok, new_topic}
  """

  def add_association(new_assoc, parent_object, atom_name, assoc_func) do
    parent_object
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(atom_name, assoc_func.(new_assoc))
    |> Repo.update!()
  end

  def check_for_existing_time_period({:existing, topic}) do
    case Repo.preload(topic, [:time_period]) do
      %{time_period: nil} ->
        {:existing, topic}

      %{time_period: _found} = with_period ->
        {:has_time_period, with_period}
    end
  end

  def check_for_existing_time_period(any), do: any

  def create_if_new({:new, new_topic}), do: TopicContext.create_topic_from_struct(new_topic)
  def create_if_new({:existing, topic}), do: {:existing, topic}
end
