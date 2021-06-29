defmodule MetapedeWeb.LiveComponents.BreadcrumbsComponent do
  use MetapedeWeb, :live_component
  alias MetapedeWeb.LiveComponents.Crumb

  def render(assigns) do
    ~L"""
    <div>
        <span>
            <%= @root %>
        </span>
        <%= for crumb <- Enum.reverse(@breadcrumbs) do %>
            <%= live_component @socket, Crumb, crumb: crumb %>
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
    <span> > <%= elem(@crumb, 0) %></span>
    """
  end
end
