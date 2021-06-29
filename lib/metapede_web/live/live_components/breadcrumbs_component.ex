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
    <span> >
    <%= live_patch elem(@crumb, 0), to: Routes.time_period_show_path(@socket, :show, elem(@crumb, 1))%>
    </span>
    """
  end
end
