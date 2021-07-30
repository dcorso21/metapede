defmodule MetapedeWeb.LiveComponents.BreadcrumbsComponent do
  use MetapedeWeb, :live_component
  alias MetapedeWeb.LiveComponents.Crumb

  def render(assigns) do
    ~L"""
    <div class="breadcrumbs">

        <%# Root Crumb %>
        <div class="crumb">
          <span>
            <%= live_patch @root, to: @root_path%>
          </span>
        </div>

        <%# Caret %>
        <div class="caret">></div>

        <%# Middle Crumbs %>
        <%= for { crumb, index } <- Enum.with_index(@breadcrumbs) do %>
            <%= live_component @socket,
              Crumb,
              crumb: crumb,
              index: index,
              target: @myself
            %>
        <% end %>

        <%# Current Crumb %>
        <div class="crumb">
            <span>
              <%= @current_title %>
            </span>
        </div>

    </div>
    """
  end

  def handle_event("clicked_breadcrumb_" <> index, _, socket) do
    updated_breadcrumbs =
      socket.assigns.breadcrumbs
      |> Enum.take(String.to_integer(index))

    {:noreply, socket |> assign(breadcrumbs: updated_breadcrumbs)}
  end

  # defp convert_current_to_crumb(socket) do
  #   tp = socket.assigns.time_period
  #   [%{"name" => tp.topic.title, "id" => tp.id}]
  # end
end
