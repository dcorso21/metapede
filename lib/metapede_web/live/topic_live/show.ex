defmodule MetapedeWeb.TopicLive.Show do
  use MetapedeWeb, :live_view
  alias Metapede.Collection
  # alias Metapede.Collection.{Topic}
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
        # add_sub_topic(new_sub_topic, socket, :new)
        test_add(new_sub_topic, socket)

      [_id] ->
        IO.puts("Existing")
        add_sub_topic(new_sub_topic, socket)
    end
  end

  defp test_add(topic, socket) do
    result =
      topic
      |> Map.put("parent_topics", [socket.assigns.topic])
      |> Collection.create_topic()

    case result do
      {:ok, _topic} ->
        {:noreply, socket}
      {:error, message} ->
        IO.puts(inspect(message))
        {:noreply, socket}
    end
  end

  defp add_sub_topic(sub_topic, socket, :new) do
    case Collection.create_topic(sub_topic) do
      {:ok, topic} ->
        IO.puts("New Topic Created:")
        IO.puts(inspect(topic))
        add_sub_topic(topic, socket)

      {:error, message} ->
        IO.puts(message)
        {:noreply, socket}
    end
  end

  defp add_sub_topic(sub_topic, socket) do
    updated =
      socket.assigns.topic
      |> Map.update(
        :sub_topics,
        [],
        fn current_sub_topics -> [sub_topic | current_sub_topics] end
      )
      |> Map.take([:title, :description, :thumbnail, :page_id, :sub_topics, :id])

    IO.puts("Updated:")
    IO.puts(inspect(updated))

    # case Collection.update_sub_topics(updated) do
    #   {:ok, topic} ->
    #     {:ok, assign(socket, :topic, topic)}

    #   {:error, message} ->
    #     IO.puts(message)
    #     {:noreply, socket}

    #   what ->
    #     IO.puts(inspect(what))
    #     {:noreply, socket}
    # end
    # {:noreply, socket}
    IO.puts(inspect(Collection.update_sub_topics(updated)))
    {:noreply, socket}
  end

  defp page_title(:show), do: "Show Topic"
  defp page_title(:edit), do: "Edit Topic"
  defp page_title(:search), do: "Search"
end
