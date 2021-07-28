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
end

defmodule MetapedeWeb.LiveComponents.Crumb do
  use MetapedeWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="crumb">
    <span>
    <%= live_patch @crumb["name"],
      to: Routes.time_period_show_path(@socket, :main, @crumb["id"]),
      phx_click: "reset_breadcrumbs" <> Integer.to_string(@index)
    %>
    </span>
    </div>
    <div class="caret">></div>
    """
  end
end
