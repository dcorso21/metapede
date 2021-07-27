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
end
