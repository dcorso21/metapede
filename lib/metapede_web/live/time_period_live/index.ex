defmodule MetapedeWeb.TimePeriodLive.Index do
  use MetapedeWeb, :live_view
  alias Metapede.TimelineContext.TimePeriodContext
  alias Metapede.TopicSchema.TopicContext
  alias MetapedeWeb.Controllers.Transforms.DatetimeOps

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(time_periods: TimePeriodContext.list_time_periods())
     |> assign(breadcrumbs: [{"hello", nil}])
     |> assign(new_topic: %{})}
  end

  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(time_periods: TimePeriodContext.list_time_periods())}
  end

  def handle_event("delete_all", _, socket) do
    Metapede.Repo.delete_all(Metapede.Timeline.TimePeriodSchema.TimePeriod)

    {:noreply,
     socket
     |> assign(time_periods: TimePeriodContext.list_time_periods())}
  end

  def handle_event("update_breadcrumbs", _data, socket), do: {:noreply, socket}

  def handle_event("new_time_period", %{"topic" => wiki_topic}, socket) do
    topic_info = TopicContext.decode_and_format_topic(wiki_topic)

    {:noreply,
     socket
     |> assign(:new_topic, topic_info)
     |> push_patch(to: Routes.time_period_index_path(socket, :confirm))}
  end

  def handle_event("save_period", params, socket) do
    new_period = %{
      start_datetime: DatetimeOps.make_datetimes(params, "sdt"),
      end_datetime: DatetimeOps.make_datetimes(params, "edt")
    }

    {status, message} =
      TimePeriodContext.create_new_with_topic(new_period, socket.assigns.new_topic)

    {:noreply,
     socket
     |> put_flash(status, message)
     |> push_patch(to: Routes.time_period_index_path(socket, :main))}
  end
end
