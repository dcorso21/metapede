defmodule MetapedeWeb.TimePeriodLive.Show do
  use MetapedeWeb, :live_view
  alias Metapede.TimelineContext.TimePeriodContext
  # alias Metapede.CommonSearchFuncs

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
    Phoenix.View.render(MetapedeWeb.Pages, "time_period_show.html", assigns)
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

  def handle_info({:right_info_pid, pid}, socket) do
    IO.puts("Saving now!!!")
    {:noreply, socket |> assign(right_info_pid: pid)}
  end

end
