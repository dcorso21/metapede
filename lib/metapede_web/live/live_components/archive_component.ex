defmodule MetapedeWeb.LiveComponents.ArchiveComponent do
  use MetapedeWeb, :live_component
  alias MetapedeWeb.LiveComponents.Resources.TimePeriodComponent
  alias MetapedeWeb.LiveComponents.Resources.EventComponent
  alias MetapedeWeb.LiveComponents.Resources.TopicComponent

  def update(assigns, socket) do
    class_name = "#{assigns.archive["resource_type"]} #{assigns.display_mode}"

    {:ok,
     socket
     |> assign(:archive, assigns.archive)
     |> assign(:expand_component, assigns.expand_component)
     |> assign(:class_name, class_name)
     |> assign(:display_mode, assigns.display_mode)
     |> assign(:res_type, assigns.archive["resource_type"])
     |> assign(:component, get_resource_component(assigns.archive))}
  end

  def render(assigns) do
    ~L"""
    <div class="archive <%= @class_name %>">

      <%= live_component TopicComponent,
        topic: @archive["data"]["topic"],
        res_type: @res_type,
        page_route: Routes.archives_show_path(@socket, :main, @archive["_id"]),
        display_mode: @display_mode,
        expanded: @expand_component,
        target: @myself
      %>

      <%= if @expand_component do %>
      <div class="resource_wrap">
        <%= live_component @component,
          resource: @archive["data"],
          id: @archive["data"]["_id"] %>
      </div>
      <% end %>
    </div>
    """
  end

  def handle_event("expand_component", _, socket) do
    {:noreply, socket |> assign(:expand_component, !socket.assigns.expand_component)}
  end

  defp get_resource_component(archive) do
    component_types = %{
      "time_period" => TimePeriodComponent,
      "event" => EventComponent
    }

    component_types[archive["resource_type"]]
  end
end
