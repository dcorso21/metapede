defmodule MetapedeWeb.LiveComponents.ProjectComponent do
  use MetapedeWeb, :live_component

  def render(assigns) do
    ~L"""

    <%= live_redirect to: Routes.projects_show_path(@socket, :main, @project["topic"]["title"]) do %>

      <img src="<%= @project["topic"]["thumbnail"] %>">
      <div class="title">
        <%= @project["topic"]["title"] %>
      </div>
      <div class="title">
        <%= @project["topic"]["description"] %>
      </div>

    <% end %>
    """
  end
end
