defmodule MetapedeWeb.LiveComponents.SubPeriodsHook do
  use MetapedeWeb, :live_component

  def render(assigns) do
    ~L"""
        <div
            phx-hook="subPeriodHook"
            id="sub_period_wrap"
            phx-update="ignore"
            data-main_period="<%= Poison.encode!(
            Map.drop(@time_period, [:sub_time_periods])
            ) %>"
            data-sub_periods="<%= Poison.encode!(@loaded_sub_periods) %>"
        ></div>
    """
  end

  def handle_event("click_period", period_clicked, socket) do
    updated = ManageShown.path_helper(period_clicked["id"], socket.assigns.loaded_sub_periods)
    {:noreply, socket |> assign(loaded_sub_periods: updated.sub_time_periods)}
  end
end
