defmodule MetapedeWeb.LiveComponents.ArchiveComponent do
  use MetapedeWeb, :live_component
  alias MetapedeWeb.LiveComponents.Resources.TimePeriodComponent
  alias MetapedeWeb.LiveComponents.Resources.EventComponent

  @component_types %{
    "time_period" => TimePeriodComponent,
    "event" => EventComponent
  }

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(:archive, assigns.archive)
     |> assign(:topic, assigns.archive["data"]["topic"])
     |> assign(:res_type, assigns.archive["resource_type"])
     |> assign(:component, @component_types[assigns.archive["resource_type"]])}
  end

  def render(assigns) do
    ~L"""


    <div class="res_type <%= @res_type %>">
    <%= @res_type %>
    </div>

    <%= live_redirect to: Routes.archives_show_path(@socket, :main, @archive["_id"]) do %>
    <div>click me</div>
    <% end %>

      <img src="<%= @topic["thumbnail"] %>">

      <div class="title">
        <%= @topic["title"] %>
      </div>

      <div class="description">
        <%= @topic["description"] %>
      </div>
      <%= live_component @component, resource: @archive["data"], id: @archive["data"]["_id"] %>

    """
  end
end
