defmodule MetapedeWeb.LiveComponents.BreadcrumbsComponent do
  use MetapedeWeb, :live_component
  alias MetapedeWeb.LiveComponents.Crumb

  def render(assigns) do
    ~L"""
    <div>
        <span>
              <%= live_patch @root, to: @root_path%>
        </span>
        <%= for { crumb, index } <- Enum.with_index(Enum.reverse(@breadcrumbs)) do %>
            <%= live_component @socket, Crumb, crumb: crumb, index: index %>
        <% end %>
        <span> > <%= @current_title %></span>
    </div>
    """
  end
end

defmodule MetapedeWeb.LiveComponents.Crumb do
  use MetapedeWeb, :live_component

  def render(assigns) do
    ~L"""
    <span> >
        <%= live_patch elem(@crumb, 0),
        to: Routes.time_period_show_path(@socket, :show, elem(@crumb, 1)),
        phx_click: "reset_breadcrumbs" <> Integer.to_string(@index)
        %>
    </span>
    """
  end
end
