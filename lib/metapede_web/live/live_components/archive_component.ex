defmodule MetapedeWeb.LiveComponents.ArchiveComponent do
  use MetapedeWeb, :live_component
  alias Metapede.Db.Schemas.Archive
  alias MetapedeWeb.LiveComponents.Resources.TimePeriodComponent
  alias MetapedeWeb.LiveComponents.Resources.EventComponent
  alias MetapedeWeb.LiveComponents.Resources.TopicComponent

  def mount(socket) do
    {:ok, socket |> assign(menu_is_open: false)}
  end

  def update(assigns, socket) do
    class_name = "#{assigns.archive["resource_type"]} #{assigns.display_mode}"

    {:ok,
     socket
     |> assign(:archive, assigns.archive)
     |> assign(:return_to, assigns.return_to)
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

      <i
      phx-target="<%= @myself %>"
      phx-click="open_menu"
      class="archive_context_menu fas fa-ellipsis-h">
      <%= if @menu_is_open do %>
      <div class="context_menu">
        <div
          phx-target="<%= @myself %>"
          phx-click="delete_archive"
          class="menu_option">
        Delete
        </div>
      </div>
      <% end %>
      </i>
    </div>
    """
  end

  def handle_event("expand_component", _, socket) do
    {:noreply, socket |> assign(:expand_component, !socket.assigns.expand_component)}
  end

  def handle_event("open_menu", _, socket), do: {:noreply, socket |> assign(menu_is_open: true)}

  def handle_event("delete_archive", _, socket) do
    Archive.delete(socket.assigns.archive["_id"])
    {:noreply, socket
    |> push_patch(to: socket.assigns.return_to)
    |> put_flash(:error, "Archive deleted")
  }
  end

  defp get_resource_component(archive) do
    component_types = %{
      "time_period" => TimePeriodComponent,
      "event" => EventComponent
    }

    component_types[archive["resource_type"]]
  end
end
