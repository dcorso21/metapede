defmodule MetapedeWeb.LiveComponents.SubPeriodsHook do
  use MetapedeWeb, :live_component
  alias MetapedeWeb.Controllers.Transforms.ManageShown

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(time_period: assigns.time_period)
     |> assign(loaded_sub_periods: assigns.time_period |> initialize_sub_periods)}
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

  def handle_event("click_period", period_clicked, socket) do
    updated = ManageShown.path_helper(period_clicked["id"], socket.assigns.loaded_sub_periods)
    {:noreply, socket |> assign(loaded_sub_periods: updated.sub_time_periods)}
  end

  defp initialize_sub_periods(time_period) do
    time_period.sub_time_periods
    |> Metapede.Repo.preload([:topic, :sub_time_periods])
    |> Enum.map(fn period -> Map.put(period, :expand, false) end)
    |> Enum.map(fn period ->
      Map.put(period, :has_sub_periods, length(period.sub_time_periods) > 0)
    end)
  end
end
