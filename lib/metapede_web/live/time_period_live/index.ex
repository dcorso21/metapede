defmodule MetapedeWeb.TimePeriodLive.Index do
  use MetapedeWeb, :live_view
  alias Metapede.TimelineContext.TimePeriodContext
  alias Metapede.Collection

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(time_periods: TimePeriodContext.list_time_periods())
     |> assign(breadcrumbs: [{"hello", nil}])
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

  def handle_event("update_breadcrumbs", _data, _socket), do: nil

  def handle_event("new_time_period", %{"topic" => selected_topic}, socket) do
    selected_topic
    |> Metapede.CommonSearchFuncs.decode_and_format_topic()
    |> Metapede.CommonSearchFuncs.create_if_new()
    |> Metapede.CommonSearchFuncs.check_for_existing_time_period()
    |> custom_redirect(socket)
  end

  def handle_event("save_period", %{"Elixir.Metapede.Timeline.TimePeriod" => new_period}, socket) do
    case TimePeriodContext.create_time_period(new_period) do
      {:ok, saved_period} ->
        loaded = Metapede.Repo.preload(saved_period, [:topic])

        Metapede.CommonSearchFuncs.add_association(
          socket.assigns.new_topic,
          loaded,
          :topic,
          fn el -> el end
        )

        {:noreply,
         socket
         |> put_flash(:info, "New Time Period Created")
         |> push_redirect(to: Routes.time_period_index_path(socket, :main))}

      {:error, message} ->
        IO.puts(inspect(message))

        {:noreply,
         socket
         |> put_flash(:error, "An Error Occurred")
         |> push_redirect(to: Routes.time_period_index_path(socket, :main))}
    end
  end

  defp custom_redirect({:ok, topic}, socket),
    do: send_patch(topic, "Topic created successfully", socket)

  defp custom_redirect({:existing, topic}, socket),
    do: send_patch(topic, "Topic created Topic Found", socket)

  defp custom_redirect({:has_time_period, topic}, socket),
    do: send_patch(topic, "#{topic.title} already has a time period associated with it.", socket)

  defp custom_redirect({:error, _changeset}, socket),
    do: send_patch(:error, " An error has occurred", socket)

  defp send_patch(topic, message, socket) do
    {:noreply,
     socket
     |> put_flash(:info, message)
     |> assign(:new_topic, topic)
     |> push_redirect(to: Routes.time_period_index_path(socket, :confirm, topic.id, [topic]))}
  end

  defp send_patch(:error, message, socket) do
    {:noreply,
     socket
     |> put_flash(:error, message)
     |> push_redirect(to: Routes.time_period_index_path(socket, :main))}
  end
end
