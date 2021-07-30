defmodule MetapedeWeb.LiveComponents.TimePeriod.TimePeriodComponent do
  use MetapedeWeb, :live_component

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(:period, assigns.period)
     |> assign(:trace, make_trace(assigns))
     |> assign(:patch, assigns.patch)
     |> assign(:show_sub_periods, false)}
  end

  # defp make_trace(%{"trace" => trace}), do: trace
  defp make_trace(%{trace: trace}), do: trace
  defp make_trace(_assigns), do: []

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
          <div
            phx-click="update_breadcrumbs"
            phx-value-breadcrumbs="<%= Poison.encode!(@trace) %>"
            >
          <%= if @patch do %>
            <%= live_patch "Show Period", to: Routes.time_period_show_path(@socket, :main, @period)%>
          <% else %>
            <%= live_redirect "Show Period", to: Routes.time_period_show_path(@socket, :main, @period)%>
          <% end %>
          </div>

          </div>
        <%= if @show_sub_periods do %>

            <%= for period <- Metapede.Repo.preload(@period.sub_time_periods, [:topic, :sub_time_periods]) do %>
                <%= live_component @socket,
                    MetapedeWeb.LiveComponents.TimePeriod.TimePeriodComponent,
                    period: period,
                    trace: @trace ++ [%{"name" => @period.topic.title, "id" => @period.id}],
                    id: "parent_#{@period.id}_sub_#{period.id}",
                    patch: @patch
                %>
            <% end %>
        <% end %>
    </div>
    """
  end

  def handle_event("show_sub_periods", _, socket) do
    update = if socket.assigns.show_sub_periods, do: false, else: true
    {:noreply, socket |> assign(:show_sub_periods, update)}
  end
end
