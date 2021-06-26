defmodule MetapedeWeb.TimePeriodLive.Index do
  use MetapedeWeb, :live_view
  alias Metapede.TimelineContext.TimePeriodContext
  alias Metapede.Collection
  # alias Metapede.Collection.Topic
  alias MetapedeWeb.Controllers.Transforms.WikiTransforms

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(time_periods: TimePeriodContext.list_time_periods())
     |> assign(new_topic: %{})}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    new_topic = Collection.get_topic!(id)

    {:noreply,
     socket
     |> assign(new_topic: new_topic)}
  end

  def handle_params(_params, _url, socket), do: {:noreply, socket}

  def handle_event("delete_all", _, socket) do
    Metapede.Repo.delete_all(Metapede.Timeline.TimePeriod)

    {:noreply,
     socket
     |> assign(time_periods: TimePeriodContext.list_time_periods())}
  end

  def handle_event("new_time_period", %{"data" => selected_topic}, socket) do
    data =
      Poison.decode!(selected_topic)
      |> WikiTransforms.transform_wiki_data()

    IO.puts(inspect(data))

    # {:noreply, socket}
    case Collection.create_topic(data) do
      {:ok, new_topic} ->
        {:noreply,
         socket
         |> put_flash(:info, "Topic created successfully")
         |> assign(:new_topic, new_topic)
         |> push_redirect(
           to: Routes.time_period_index_path(socket, :confirm, new_topic.id, [new_topic])
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
