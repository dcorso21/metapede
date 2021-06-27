defmodule MetapedeWeb.LiveComponents.TimePeriod.TimePeriodComponent do
  use MetapedeWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="period_wrapper">
        <img src="<%= @period.topic.thumbnail %>" alt="">
        <div class="info_center">
            <div class="period_title">
                <%= @period.topic.title %>
            </div>
            <div class="period_desc">
                <%= @period.topic.description %>
            </div>
        </div>
        <div><%= @period.start_datetime %> - <%= @period.end_datetime %></div>
        <span><%= live_redirect "Show", to: Routes.time_period_show_path(@socket, :show, @period) %></span>
    </div>
    """
  end
end
