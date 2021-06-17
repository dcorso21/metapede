defmodule MetapedeWeb.TopicLive.Show do
  use MetapedeWeb, :live_view
  alias Metapede.Collection
  alias Metapede.Repo
  alias Metapede.Collection.Topic
  alias MetapedeWeb.Controllers.Transforms.WikiTransforms

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:topic, Collection.get_topic!(id))}
  end

  @impl true
  def handle_event("send_topic", %{"data" => selected_topic}, socket) do
    new_sub_topic =
      Poison.decode!(selected_topic)
      |> WikiTransforms.transform_wiki_data()

    existing_ids = Collection.check_for_page_id(new_sub_topic["page_id"])

    case existing_ids do
      [] ->
        IO.puts("New")
        test_add(new_sub_topic, socket)

      [_id] ->
        IO.puts("Existing")
        test_add(new_sub_topic, socket)
    end
  end

  def handle_event("delete", %{"id" => id}, socket) do
    topic = Collection.get_topic!(id)
    {:ok, _} = Collection.delete_topic(topic)
    {:noreply, assign(socket, :topic, Collection.get_topic!(socket.assigns.topic.id))}
  end

  defp test_add(new_topic, socket) do
    IO.puts("New Topic")
    IO.puts(inspect(new_topic))

    new_sub_topic = Topic.changeset(%Topic{}, new_topic)
    parent_topic = socket.assigns.topic

    parent_topic
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:sub_topics, [new_sub_topic | parent_topic.sub_topics])
    |> Repo.update!()

    {:noreply,
     socket
     |> put_flash(:info, "Subtopic Added")
     |> push_redirect(to: Routes.topic_show_path(socket, :show, socket.assigns.topic))}
  end

  defp page_title(:show), do: "Show Topic"
  defp page_title(:edit), do: "Edit Topic"
  defp page_title(:search), do: "Search"
end
