defmodule MetapedeWeb.TopicLive.Show do
  use MetapedeWeb, :live_view
  alias Metapede.TopicSchema.TopicContext
  alias Metapede.CommonSearchFuncs

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    topic = TopicContext.get_topic!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:topic, topic)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    topic = TopicContext.get_topic!(id)
    {:ok, _} = TopicContext.delete_topic(topic)
    {:noreply, assign(socket, :topic, TopicContext.get_topic!(socket.assigns.topic.id))}
  end

  def handle_event("new_sub_topic", %{"topic" => topic}, socket) do
    sub_topic = TopicContext.decode_and_format_topic(topic)
    add_func = fn el -> [el | socket.assigns.topic.sub_topics] end
    CommonSearchFuncs.add_association(sub_topic, socket.assigns.topic, :sub_topics, add_func)

    {:noreply,
     socket
     |> put_flash(:info, "new subtopic added")
     |> push_redirect(to: Routes.topic_show_path(socket, :show, socket.assigns.topic))}
  end

  defp page_title(:show), do: "Show Topic"
  defp page_title(:edit), do: "Edit Topic"
  defp page_title(:search), do: "Search"
end
