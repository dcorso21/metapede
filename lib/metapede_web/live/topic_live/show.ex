defmodule MetapedeWeb.TopicLive.Show do
  use MetapedeWeb, :live_view
  alias Metapede.Collection
  alias Metapede.Repo
  alias Metapede.Collection.Topic
  alias MetapedeWeb.Controllers.Transforms.WikiTransforms

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    topic = Collection.get_topic!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:topic, topic)}
  end

  # @impl true

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    topic = Collection.get_topic!(id)
    {:ok, _} = Collection.delete_topic(topic)
    {:noreply, assign(socket, :topic, Collection.get_topic!(socket.assigns.topic.id))}
  end

  def handle_event("new_sub_topic", %{"data" => selected_topic}, socket) do
    sub_topic =
      Poison.decode!(selected_topic)
      |> WikiTransforms.transform_wiki_data()

    existing_ids = Collection.check_for_page_id(sub_topic["page_id"])

    case existing_ids do
      [] ->
        IO.puts("New")
        params = get_sub_topic(sub_topic, nil, :new)
        test_add(params, socket)

      [id] ->
        IO.puts("Existing")
        params = get_sub_topic(nil, id, :existing)
        test_add(params, socket)
    end
  end

  defp test_add(new_topic, socket) do
    parent_topic = socket.assigns.topic

    parent_topic
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:sub_topics, [new_topic | parent_topic.sub_topics])
    |> Repo.update!()

    {:noreply,
     socket
     |> put_flash(:info, "Subtopic Added")
     |> push_redirect(to: Routes.topic_show_path(socket, :show, socket.assigns.topic))}
  end

  defp get_sub_topic(_params, id, :existing), do: Collection.get_topic!(id)
  defp get_sub_topic(params, _id, :new), do: Topic.changeset(%Topic{}, params)

  defp page_title(:show), do: "Show Topic"
  defp page_title(:edit), do: "Edit Topic"
  defp page_title(:search), do: "Search"
end
