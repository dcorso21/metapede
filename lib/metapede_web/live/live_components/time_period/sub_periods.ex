defmodule MetapedeWeb.LiveComponents.TimePeriod.SubPeriodComponent do
  use MetapedeWeb, :live_component

  def render(assigns) do
    ~L"""
    <h2>Sub Periods</h2>

    <%# Forms (Modals) %>
    <%= live_component @socket,
        MetapedeWeb.LiveComponents.TimePeriod.SubPeriodForms,
        id: "sub_period_forms",
        live_action: @live_action,
        new_topic: @new_topic,
        time_period: @time_period
    %>


    <%# Add Sub Period Button %>
    <%= live_patch "Add Sub Period",
        to: Routes.time_period_show_path(
        @socket,
        :search_sub_period,
        @time_period
        )
    %>

    <%# Period Hook %>
    <%= live_component @socket,
        MetapedeWeb.LiveComponents.SubPeriodsHook,
        id: :sub_period_wrap,
        time_period: @time_period
    %>
    """
  end
end
