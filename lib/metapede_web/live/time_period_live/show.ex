defmodule MetapedeWeb.TimePeriodLive.Show do
  use MetapedeWeb, :live_view
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
     |> assign(breadcrumbs: [])}
  end

  def render(assigns) do
    Phoenix.View.render(MetapedeWeb.PageViews, "time_period_show.html", assigns)
  end

  def handle_params(params, _url, socket) do
    tp = get_time_period(params)

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
     |> push_patch(to: Routes.time_period_show_path(socket, :main, par_period))}
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
            :confirm_sub_period,
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
        to: Routes.time_period_show_path(socket, :main, socket.assigns.time_period)
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

end
