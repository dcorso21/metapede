defmodule MetapedeWeb.LiveComponents.ArchiveComponent do
  use MetapedeWeb, :live_component

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(:archive, assigns.archive)
     |> assign(:topic, assigns.archive["data"]["topic"])
     |> assign(:res_type, assigns.archive["resource_type"])}
  end

  def render(assigns) do
    ~L"""

    <%= live_redirect to: Routes.archives_show_path(@socket, :main, @archive["_id"]) do %>

      <div class="res_type <%= @res_type %>">
        <%= @res_type %>
      </div>

      <img src="<%= @topic["thumbnail"] %>">

      <div class="title">
        <%= @topic["title"] %>
      </div>

      <div class="description">
        <%= @topic["description"] %>
      </div>

    <% end %>
    """
  end
end
