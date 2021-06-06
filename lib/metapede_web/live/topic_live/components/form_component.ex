defmodule MetapedeWeb.TopicLive.FormComponent do
  use MetapedeWeb, :live_component

  alias Metapede.Collection

  @impl true
  def update(%{topic: topic} = assigns, socket) do
    changeset = Collection.change_topic(topic)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"topic" => topic_params}, socket) do
    changeset =
      socket.assigns.topic
      |> Collection.change_topic(topic_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"topic" => topic_params}, socket) do
    save_topic(socket, socket.assigns.action, topic_params)
  end

  defp save_topic(socket, :edit, topic_params) do
    case Collection.update_topic(socket.assigns.topic, topic_params) do
      {:ok, _topic} ->
        {:noreply,
         socket
         |> put_flash(:info, "Topic updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_topic(socket, :new, topic_params) do
    case Collection.create_topic(topic_params) do
      {:ok, _topic} ->
        {:noreply,
         socket
         |> put_flash(:info, "Topic created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
