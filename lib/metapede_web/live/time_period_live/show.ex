defmodule MetapedeWeb.TimePeriodLive.Show do
  use MetapedeWeb, :live_view
  alias Metapede.CommonSearchFuncs

  def handle_params(%{"id" => id}, _url, socket) do
    tp = Metapede.TimelineContext.TimePeriodContext.get_time_period!(id)
    {:noreply, socket |> assign(time_period: tp)}
  end

  def handle_event("new_sub_time_period", %{"topic" => topic}, socket) do
    new_topic =
      topic
      |> CommonSearchFuncs.decode_and_format_topic
      |> CommonSearchFuncs.create_if_new
      |> CommonSearchFuncs.check_for_existing_time_period

    {:noreply,
     socket
     |> put_flash(:info, "Test successful")
     |> push_redirect(to: Routes.time_period_show_path(socket, :show, socket.assigns.time_period))
     |> assign(new_topic: new_topic)}
  end
end
