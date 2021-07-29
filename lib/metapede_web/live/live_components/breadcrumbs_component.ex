defmodule MetapedeWeb.LiveComponents.BreadcrumbsComponent do
  use MetapedeWeb, :live_component
  alias MetapedeWeb.LiveComponents.Crumb

  def render(assigns) do
    ~L"""
    <div class="breadcrumbs">
        <div class="crumb">
          <span>
            <%= live_patch @root, to: @root_path%>
          </span>
          </div>
            <div class="caret">></div>
            <%= for { crumb, index } <- Enum.with_index(@breadcrumbs) do %>
                <%= live_component @socket, Crumb, crumb: crumb, index: index %>
            <% end %>
            <div class="crumb">
            <span>
              <%= @current_title %>
            </span>
        </div>
    </div>
    """
  end

  def handle_event("reset_breadcrumbs" <> index, _, socket) do
    updated_breadcrumbs =
      socket.assigns.breadcrumbs
      |> Enum.take(String.to_integer(index))

    {:noreply, socket |> assign(breadcrumbs: updated_breadcrumbs)}
  end

end

