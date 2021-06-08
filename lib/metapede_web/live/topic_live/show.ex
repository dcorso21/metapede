defmodule MetapedeWeb.TopicLive.Show do
  use MetapedeWeb, :live_view
  alias Metapede.Collection

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:topic, Collection.get_topic!(id))}
  end

  @impl true
  def handle_event("send_topic", %{"data" => selected_topic}, socket) do
    data = Poison.decode!(selected_topic)
    IO.puts(inspect(data))
    {:noreply, socket}
  end


  defp page_title(:show), do: "Show Topic"
  defp page_title(:edit), do: "Edit Topic"
  defp page_title(:search), do: "Search"
end
