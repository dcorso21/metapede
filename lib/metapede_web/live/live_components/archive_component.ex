defmodule MetapedeWeb.LiveComponents.ArchiveComponent do
  use MetapedeWeb, :live_component
  alias MetapedeWeb.LiveComponents.Resources.TimePeriodComponent
  alias MetapedeWeb.LiveComponents.Resources.EventComponent

  def update(assigns, socket) do
    className = "#{assigns.archive["resource_type"]} #{assigns.display_mode}"

    {:ok,
     socket
     |> assign(:archive, assigns.archive)
     |> assign(:className, className)
     |> assign(:topic, assigns.archive["data"]["topic"])
     |> assign(:res_type, assigns.archive["resource_type"])
     |> assign(:component, get_resource_component(assigns.archive))}
  end

  def render(assigns) do
    ~L"""
    <div class="archive <%= @className %>">
      <div class="res_type">
      <%= @res_type %>
      </div>

        <%= live_redirect to: Routes.archives_show_path(@socket, :main, @archive["_id"]) do %>
        <div>go to page</div>
        <% end %>

        <img src="<%= @topic["thumbnail"] %>">

        <div class="title">
          <%= @topic["title"] %>
        </div>

        <div class="description">
          <%= @topic["description"] %>
        </div>
      </div>
      <%= live_component @component, resource: @archive["data"], id: @archive["data"]["_id"] %>

    """
  end

  defp get_resource_component(archive) do
    component_types = %{
      "time_period" => TimePeriodComponent,
      "event" => EventComponent
    }

    component_types[archive["resource_type"]]
  end
end
