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

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    topic = Collection.get_topic!(id)
    {:ok, _} = Collection.delete_topic(topic)
    {:noreply, assign(socket, :topic, Collection.get_topic!(socket.assigns.topic.id))}
  end

  def handle_event("new_sub_topic", %{"topic" => topic}, socket) do
    sub_topic =
      Poison.decode!(topic)
      |> WikiTransforms.transform_wiki_data()

    # Get id if existing
    existing_ids = Collection.check_for_page_id(sub_topic["page_id"])
    # Make new topic or retrieve existing.
    new_topic = get_topic_info(sub_topic, existing_ids)
    # Define how to add subtopic
    add_func = fn el -> [el | socket.assigns.topic.sub_topics] end
    # add the association
    add_association(new_topic, socket.assigns.topic, :sub_topics, add_func)

    {:noreply,
     socket
     |> put_flash(:info, "new subtopic added")
     |> push_redirect(to: Routes.topic_show_path(socket, :show, socket.assigns.topic))}
  end

  defp add_association(new_assoc, parent_object, atom_name, assoc_func) do
    parent_object
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(atom_name, assoc_func.(new_assoc))
    |> Repo.update!()
  end

  defp get_topic_info(_params, [id]), do: Collection.get_topic!(id)
  defp get_topic_info(params, []), do: Topic.changeset(%Topic{}, params)

  defp page_title(:show), do: "Show Topic"
  defp page_title(:edit), do: "Edit Topic"
  defp page_title(:search), do: "Search"
end
