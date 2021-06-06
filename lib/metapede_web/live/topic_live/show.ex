defmodule MetapedeWeb.TopicLive.Show do
  use MetapedeWeb, :live_view
  alias Metapede.Collection

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:topic, Collection.get_topic!(id))}
  end

  defp arr_associations(sub_topics) when not is_list(sub_topics), do: []
  defp arr_associations(sub_topics), do: sub_topics

  defp page_title(:show), do: "Show Topic"
  defp page_title(:edit), do: "Edit Topic"
end
