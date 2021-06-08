defmodule MetapedeWeb.TopicLive.Topics do
  use MetapedeWeb, :live_view
  alias Metapede.Collection
  alias Metapede.Collection.Topic
  alias MetapedeWeb.Controllers.Transforms.WikiTransforms

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :show_topics, list_topics())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    topic = Collection.get_topic!(id)
    {:ok, _} = Collection.delete_topic(topic)
    {:noreply, assign(socket, :show_topics, list_topics())}
  end

  def handle_event("send_topic", %{"data" => selected_topic}, socket) do
    data =
      Poison.decode!(selected_topic)
      |> WikiTransforms.transform_wiki_data()

    IO.puts inspect(data)

    {:noreply, socket}
    # case Collection.create_topic(data) do
    #   {:ok, _topic} ->
    #     {:noreply,
    #      socket
    #      |> put_flash(:info, "Topic created successfully")
    #      |> push_redirect(to: socket.assigns.return_to)}

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     {:noreply, assign(socket, changeset: changeset)}
    # end
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Topic")
    |> assign(:topic, Collection.get_topic!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Topic")
    |> assign(:topic, %Topic{})
  end

  defp apply_action(socket, :topics, _params) do
    socket
    |> assign(:page_title, "Listing Topics")
    |> assign(:topic, nil)
  end

  defp apply_action(socket, :search, _params) do
    socket
    |> assign(:page_title, "Searching Wikipedia")
    |> assign(:topic, nil)
  end

  defp list_topics do
    Collection.list_topics()
  end
end
