defmodule MetapedeWeb.LiveComponents.ArchiveComponent do
  use MetapedeWeb, :live_component

  def render(assigns) do
    ~L"""

    <%= live_redirect to: Routes.archives_show_path(@socket, :main, @archive["_id"]) do %>

      <img src="<%= @archive["data"]["topic"]["thumbnail"] %>">
      <div class="title">
        <%= @archive["data"]["topic"]["title"] %>
      </div>
      <div class="title">
        <%= @archive["data"]["topic"]["description"] %>
      </div>

    <% end %>
    """
  end
end
