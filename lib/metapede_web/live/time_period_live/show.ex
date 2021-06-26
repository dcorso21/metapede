defmodule MetapedeWeb.TimePeriodLive.Show do
  use MetapedeWeb, :live_view
  alias Metapede.CommonSearchFuncs

  def handle_params(%{"id" => id}, _url, socket) do
    tp = Metapede.TimelineContext.TimePeriodContext.get_time_period!(id)
    {:noreply, socket |> assign(time_period: tp)}
  end

  def handle_event("new_sub_time_period", %{"topic" => _topic}, socket) do
    # sub_time_period = CommonSearchFuncs.decode_and_format_topic(topic)
    # add_func = fn el -> [el | socket.assigns.time_period.sub_time_periods] end
    # CommonSearchFuncs.add_association(sub_time_period, socket.assigns.time_period, :sub_time_period, add_func)

    {:noreply,
     socket
     |> put_flash(:info, "topic added or pulled")
     |> push_redirect(to: Routes.time_period_show_path(socket, :show, socket.assigns.time_period))}
  end

end
