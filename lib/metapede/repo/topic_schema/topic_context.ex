defmodule Metapede.TopicSchema.TopicContext do
  @moduledoc """
  The TopicContext context.
  """

  import Ecto.Query, warn: false
  alias Metapede.Repo
  alias Metapede.TopicSchema.Topic
  # alias Metapede.TopicSchema.TopicContext

  @doc """
  Returns the list of topics.

  ## Examples

      iex> list_topics()
      [%Topic{}, ...]

  """
  def list_topics do
    Topic
    |> Repo.all()
    |> Repo.preload([:sub_topics, :parent_topics])
  end

  @doc """
  Gets a single topic.

  Raises `Ecto.NoResultsError` if the Topic does not exist.

  ## Examples

      iex> get_topic!(123)
      %Topic{}

      iex> get_topic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_topic!(id) do
    Topic
    |> Repo.get!(id)
    |> Repo.preload([:sub_topics, :parent_topics])
  end

  def create_topic_from_struct(topic), do: Repo.insert(topic)

  def create_topic(topic) do
    %Topic{}
    |> Topic.changeset(topic)
    |> Repo.insert()
  end

  def create_topic!(topic) do
    %Topic{}
    |> Topic.changeset(topic)
    |> Repo.insert!()
  end

  @doc """
  Updates a topic.

  ## Examples

      iex> update_topic(topic, %{field: new_value})
      {:ok, %Topic{}}

      iex> update_topic(topic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_topic(%Topic{} = topic, attrs) do
    topic
    |> Topic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a topic.

  ## Examples

      iex> delete_topic(topic)
      {:ok, %Topic{}}

      iex> delete_topic(topic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_topic(%Topic{} = topic) do
    Repo.delete(topic)
  end

  def preload_time_period(topic) do
    topic
    |> Repo.preload([:time_period_id])
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking topic changes.

  ## Examples

      iex> change_topic(topic)
      %Ecto.Changeset{data: %Topic{}}

  """
  def change_topic(%Topic{} = topic, attrs \\ %{}) do
    Topic.changeset(topic, attrs)
  end

  def search_topics(query) do
    Repo.all(from t in Topic, where: ilike(t.title, ^"%#{query}%"))
  end

  def decode_and_format_topic(topic) do
    topic
    |> Poison.decode!()
    |> transform_wiki_data()
  end

  def transform_wiki_data(data) do
    data
    |> Map.take(["title", "description", "thumbnail"])
    |> Map.put("page_id", data["pageid"])
    |> Map.put("thumbnail", pull_url(data))
  end

  defp pull_url(%{"thumbnail" => details}), do: details["source"]
  defp pull_url(_), do: nil

  def create_or_pull(topic) do
    page_id = topic["page_id"]
    ids = Repo.all(from t in Topic, where: t.page_id == ^page_id, select: t.id)

    {topic, ids}
    |> get_topic_info()
  end

  defp get_topic_info({_params, [id]}), do: {:existing, get_topic!(id)}
  defp get_topic_info({params, []}), do: {:new, create_topic!(params)}
end
