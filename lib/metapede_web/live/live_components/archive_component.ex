defmodule MetapedeWeb.LiveComponents.ArchiveComponent do
  use MetapedeWeb, :live_component

  def render(assigns) do
    ~L"""

    <%= live_redirect to: Routes.projects_show_path(@socket, :main, @project["data"]["topic"]["title"]) do %>

      <img src="<%= @project["data"]["topic"]["thumbnail"] %>">
      <div class="title">
        <%= @project["data"]["topic"]["title"] %>
      </div>
      <div class="title">
        <%= @project["data"]["topic"]["description"] %>
      </div>

    <% end %>
    """
  end
end
