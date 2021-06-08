defmodule MetapedeWeb.TopicLive.Show do
  use MetapedeWeb, :live_view
  alias Metapede.Collection
  alias Metapede.Collection.{Topic}
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

    # selected =
    #   socket.assigns.topic
    #   |> Map.replace(:sub_topics, [new_sub_topic | socket.assigns.topic.sub_topics])

    # IO.puts(inspect(selected))

    # check db
    existing_ids = Collection.check_for_page_id(new_sub_topic["page_id"])

    case existing_ids do
      [_id] ->
        IO.puts("Existing")

      # make connection in relation table
      [] ->
        IO.puts("New")
        # create topic, then make connection
    end

    {:noreply, socket}
    # case Collection.update_topic(%Topic{}, selected) do
    #   {:ok, _topic} ->
    #     {:noreply, socket}
    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     {:noreply, assign(socket, changeset: changeset)}
    # end
  end

  defp page_title(:show), do: "Show Topic"
  defp page_title(:edit), do: "Edit Topic"
  defp page_title(:search), do: "Search"
end
