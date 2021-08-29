defmodule MetapedeWeb.LiveComponents.Resources.TopicComponent do
  use MetapedeWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="topic_component">

      <img src="<%= @topic["thumbnail"] %>">

      <div class="info">
        <div class="title_and_type">

        <%= if @display_mode === "page" do %>
            <div class="title">
              <%= @topic["title"] %>
            </div>
        <% else %>
          <%= live_redirect to: @page_route do %>
            <div class="title">
              <%= @topic["title"] %>
            </div>
          <% end %>
        <% end %>


          <div class="res_type_tag <%= @res_type %>">
            <%= @res_type %>
          </div>
          <div class="icon_tray">
            <i
              phx-click="change_page_id"
              phx-target="#right_panel_wrap"
              phx-value-page_id="<%= @topic["page_id"] %>"
              class="fab fa-wikipedia-w"></i>
            <%= if @display_mode === "embed" do %>
              <%= if @expanded do %>
                <i phx-target="<%= @target %>" phx-click="expand_component" class="fas fa-compress"></i>
              <% else %>
                <i phx-target="<%= @target %>" phx-click="expand_component" class="fas fa-expand"></i>
              <% end %>
            <% end %>
          </div>
        </div>

        <div class="description">
        <%= @topic["description"] %>
        </div>
        </div>
    </div>
    """
  end
end
