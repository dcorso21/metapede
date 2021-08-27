defmodule MetapedeWeb.LiveComponents.Resources.TimePeriodComponent do
  use MetapedeWeb, :live_component

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(time_period: assigns.resource)
     |> assign(loaded_sub_periods: assigns.resource |> initialize_sub_periods)}
  end

  def render(assigns) do
    ~L"""
    <div
        phx-hook="subPeriodHook"
        id="sub_period_wrap"
        phx-update="ignore"
        phx-target="<%= @myself %>"
        data-main_period="<%= Poison.encode!(
        Map.drop(@time_period, [:sub_time_periods])
        ) %>"
        data-sub_periods="<%= Poison.encode!(@loaded_sub_periods) %>"
    ></div>
    """
  end

  # def handle_event("click_period_body", clicked_period_id, socket) do
  #   updated = ManageShown.path_helper(clicked_period_id, socket.assigns.loaded_sub_periods)
  #   {:noreply, socket |> assign(loaded_sub_periods: updated.sub_time_periods)}
  # end

  def handle_event("click_period_title", clicked_period_id, socket) do

    IO.inspect(clicked_period_id, label: "clicked")

    {:noreply,
     socket
     |> push_redirect(to: Routes.archives_resource_page_path(socket, :main, clicked_period_id))}
  end

  defp initialize_sub_periods(time_period) do
    time_period["sub_time_periods"]
    |> Enum.map(fn period -> Map.put(period, "expand", false) end)
    |> Enum.map(fn period ->
      Map.put(period, "has_sub_periods", length(period["sub_time_periods"]) > 0)
    end)
  end
end
