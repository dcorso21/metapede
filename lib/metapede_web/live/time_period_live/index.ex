defmodule MetapedeWeb.TimePeriodLive.Index do
  use MetapedeWeb, :live_view
  alias Metapede.TimelineContext.TimePeriodContext
  alias Metapede.Collection

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(time_periods: TimePeriodContext.list_time_periods())
     |> assign(new_topic: %{})}
  end

  # For confirming topics
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

  def handle_event("new_time_period", %{"topic" => selected_topic}, socket) do
    selected_topic
    |> Metapede.CommonSearchFuncs.decode_and_format_topic
    |> Metapede.CommonSearchFuncs.create_if_new
    |> Metapede.CommonSearchFuncs.check_for_existing_time_period
    |> custom_redirect(socket)
  end

  defp custom_redirect({:ok, new_topic}, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "Topic created successfully")
     |> assign(:new_topic, new_topic)
     |> push_redirect(
       to: Routes.time_period_index_path(socket, :confirm, new_topic.id, [new_topic])
     )}
  end

  defp custom_redirect({:existing, existing_topic}, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "Topic Found")
     |> assign(:new_topic, existing_topic)
     |> push_redirect(
       to: Routes.time_period_index_path(socket, :confirm, existing_topic.id, [existing_topic])
     )}
  end

  defp custom_redirect({:has_time_period, topic}, socket) do
    {:noreply,
     socket
     |> put_flash(:error, "#{topic.title} already has a time period associated with it.")
     |> push_redirect(to: Routes.time_period_index_path(socket, :main))}
  end

  defp custom_redirect({:error, %Ecto.Changeset{} = changeset}, socket),
    do: {:noreply, assign(socket, changeset: changeset)}
end
