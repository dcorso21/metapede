defmodule MetapedeWeb.LiveComponents.TimePeriod.TimePeriodComponent do
  use MetapedeWeb, :live_component

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(:period, assigns.period)
     |> assign(:show_sub_periods, false)}
  end

  def render(assigns) do
    ~L"""
    <div class="period_outer_wrapper">
    <div class="period_inner_wrapper" phx-click="show_sub_periods" phx-target="<%= @myself %>">
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
        <div>
        <%= live_redirect "Show Period", to: Routes.time_period_show_path(@socket, :show, @period)%>
        </div>

        </div>
        <%= if @show_sub_periods do %>

            <%= for period <- Metapede.Repo.preload(@period.sub_time_periods, [:topic, :sub_time_periods]) do %>
                <%= live_component @socket, MetapedeWeb.LiveComponents.TimePeriod.TimePeriodComponent, period: period, id: period.id%>
            <% end %>
        <% end %>
    </div>
    """
  end

  def handle_event("show_sub_periods", _, socket) do
    update = if socket.assigns.show_sub_periods, do: false, else: true
    {:noreply, socket |> assign(:show_sub_periods, update)}
  end

  #   def render(assigns) do
  #     ~L"""
  #     <%= live_redirect to: Routes.time_period_show_path(@socket, :show, @period), class: "period_wrapper" do %>
  #         <img src="<%= @period.topic.thumbnail %>" alt="">
  #         <div class="info_center">
  #             <div class="period_title">
  #                 <%= @period.topic.title %>
  #             </div>
  #             <div class="period_desc">
  #                 <%= @period.topic.description %>
  #             </div>
  #         </div>
  #         <div><%= @period.start_datetime %> - <%= @period.end_datetime %></div>

  #         <%= if @show_sub_periods do %>
  #             <div>Hello</div>
  #         <% end %>
  #     <% end %>
  #     """
  #   end
end
