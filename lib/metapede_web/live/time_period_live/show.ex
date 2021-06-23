defmodule MetapedeWeb.TimePeriodLive.Show do
  use MetapedeWeb, :live_view

  def handle_params(%{"id" => id}, _url, socket) do
    tp = Metapede.TimelineContext.TimePeriodContext.get_time_period!(id)
    {:noreply, socket |> assign(time_period: tp)}
  end

  def render(assigns) do
    ~L"""
    <%= if @time_period.topic.thumbnail != nil do %>
        <img src=<%= @time_period.topic.thumbnail %>>
    <% end %>
    <h3>
        <%= @time_period.topic.title %>
    </h3>
    <div>
        <em>
            <%= @time_period.topic.description %>
        </em>
    </div>
    <div>
    id:
            <%= @time_period.id %>
    </div>
    """
  end
end
