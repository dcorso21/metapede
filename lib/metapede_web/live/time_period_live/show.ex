defmodule MetapedeWeb.TimePeriodLive.Show do
  use MetapedeWeb, :live_view
  alias MetapedeWeb.Controllers.Transforms.ManageShown
  alias Metapede.CommonSearchFuncs
  alias Metapede.TimelineContext.TimePeriodContext
  alias MetapedeWeb.Controllers.Transforms.DatetimeOps

  def mount(params, _session, socket) do
    tp = get_time_period(params)

    {:ok,
     socket
     |> assign(new_topic: nil)
     |> assign(time_period: tp)
     |> assign(refresh_sub_periods: false)
     |> assign(loaded_sub_periods: preload_sub_time_periods(tp))
     |> assign(breadcrumbs: [])}
  end

  def handle_params(params, _url, socket) do
    tp = get_time_period(params)

    socket =
      if(
        tp.id == socket.assigns.time_period.id && !socket.assigns.refresh_sub_periods,
        do: socket,
        else: socket |> assign(loaded_sub_periods: preload_sub_time_periods(tp))
      )

    new_topic =
      if(params["new_topic_id"],
        do: Metapede.Collection.get_topic!(params["new_topic_id"]),
        else: nil
      )

    {:noreply,
     socket
     |> assign(time_period: tp)
     |> assign(new_topic: new_topic)}
  end

  def get_time_period(params) do
    TimePeriodContext.get_time_period!(params["id"])
  end

  def preload_sub_time_periods(tp) do
    Metapede.Repo.preload(tp.sub_time_periods, [
      :topic,
      :sub_time_periods
    ])
    |> Enum.map(fn period -> Map.put(period, :expand, false) end)
  end

  def handle_event("click_period", period_clicked, socket) do
    updated = ManageShown.path_helper(period_clicked["id"], socket.assigns.loaded_sub_periods)
    {:noreply, socket |> assign(loaded_sub_periods: updated.sub_time_periods)}
  end

  def handle_event("redirect_to_sub_period", id, socket) do
    crumb = convert_current_to_crumb(socket)

    {:noreply,
     socket
     |> assign(breadcrumbs: socket.assigns.breadcrumbs ++ crumb)
     |> push_patch(to: Routes.time_period_show_path(socket, :show, id))}
  end

  def handle_event("new_sub_time_period", %{"topic" => topic}, socket) do
    topic
    |> CommonSearchFuncs.decode_and_format_topic()
    |> CommonSearchFuncs.create_if_new()
    |> CommonSearchFuncs.check_for_existing_time_period()
    |> custom_redirect(socket)
  end

  def handle_event("confirmed_period", params, socket) do
    new_period = %{
      start_datetime: DatetimeOps.make_datetimes(params, "sdt"),
      end_datetime: DatetimeOps.make_datetimes(params, "edt")
    }

    case TimePeriodContext.create_time_period(new_period) do
      {:ok, saved_period} ->
        loaded = Metapede.Repo.preload(saved_period, [:topic])

        resp =
          Metapede.CommonSearchFuncs.add_association(
            socket.assigns.new_topic,
            loaded,
            :topic,
            fn el -> el end
          )

        add_subtopic(resp, socket)

      {:error, message} ->
        IO.inspect(message)

        {:noreply,
         socket
         |> put_flash(:error, "An Error Occurred")
         |> push_redirect(to: Routes.time_period_index_path(socket, :main))}

      resp ->
        IO.inspect(resp)
    end
  end

  def handle_event("update_breadcrumbs", %{"breadcrumbs" => crumbs}, socket) do
    nc = crumbs |> Poison.decode!()
    cp = convert_current_to_crumb(socket)
    up = socket.assigns.breadcrumbs ++ cp ++ nc

    {:noreply,
     socket
     |> assign(breadcrumbs: up)}
  end

  def handle_event("reset_breadcrumbs" <> index, _, socket) do
    updated_breadcrumbs =
      socket.assigns.breadcrumbs
      |> Enum.take(String.to_integer(index))

    {:noreply, socket |> assign(breadcrumbs: updated_breadcrumbs)}
  end

  def handle_event("print", _, socket) do
    socket.assigns.right_info_pid
    |> send_update(MetapedeWeb.LiveComponents.ExpandInfo,
      page_id: socket.assigns.time_period.topic.page_id,
      id: "right_expand_info",
      toggle: true
    )

    {:noreply, socket}
  end

  def handle_info({:right_info_pid, pid}, socket) do
    IO.puts("Saving now!!!")
    {:noreply, socket |> assign(right_info_pid: pid)}
  end

  def add_subtopic(sub_period, socket) do
    par_period = socket.assigns.time_period

    Metapede.CommonSearchFuncs.add_association(
      sub_period,
      par_period,
      :sub_time_periods,
      fn el -> [el | par_period.sub_time_periods] end
    )

    {:noreply,
     socket
     |> assign(refresh_sub_periods: true)
     |> put_flash(:info, "New Subtopic Added: #{sub_period.topic.title}")
     |> push_patch(to: Routes.time_period_show_path(socket, :show, par_period))}
  end

  def patch_for_confirm(message, new_topic, socket) do
    IO.inspect(new_topic)

    {
      :noreply,
      socket
      |> put_flash(:info, message)
      |> assign(:new_topic, new_topic)
      |> push_patch(
        to:
          Routes.time_period_show_path(
            socket,
            :confirm,
            socket.assigns.time_period.id,
            %{"new_topic_id" => new_topic.id}
          )
      )
    }
  end

  def custom_redirect({:has_time_period, topic}, socket), do: adding(topic, socket)

  def custom_redirect({:ok, new_topic}, socket),
    do: patch_for_confirm("Topic created for timeline", new_topic, socket)

  def custom_redirect({:existing, new_topic}, socket),
    do: patch_for_confirm("Topic found", new_topic, socket)

  def adding(topic, socket) do
    topic.time_period
    |> block_self_reference(socket.assigns.time_period.id)
    |> add_to_subtopics(socket)

    {
      :noreply,
      socket
      |> put_flash(:info, "Sub Time Period Added: #{topic.title}")
      |> push_redirect(
        to: Routes.time_period_show_path(socket, :show, socket.assigns.time_period)
      )
    }
  end

  def block_self_reference(new_period, current_id) do
    if new_period.id == current_id do
      {:self, nil}
    else
      {:not_self, new_period}
    end
  end

  def add_to_subtopics({:self, _time_period}, _socket), do: nil

  def add_to_subtopics({:not_self, time_period}, socket) do
    CommonSearchFuncs.add_association(
      time_period,
      socket.assigns.time_period,
      :sub_time_periods,
      fn el ->
        [el | socket.assigns.time_period.sub_time_periods]
      end
    )
  end

  defp convert_current_to_crumb(socket) do
    tp = socket.assigns.time_period
    [%{"name" => tp.topic.title, "id" => tp.id}]
  end
end
