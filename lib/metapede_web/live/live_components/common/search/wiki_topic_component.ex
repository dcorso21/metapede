defmodule MetapedeWeb.LiveComponents.WikiTopicComponent do
  use MetapedeWeb, :live_component

  def render(assigns) do
    # phx-target="<%= @target %>"
    ~L"""
    <div
      phx-click="<%= @event_name %>"
      phx-target="<%= @target %>"
      phx-value-topic = "<%= Poison.encode!(@topic) %>"
      id="<%= @topic["pageid"] %>"
    >
      <div class="wiki_topic">
          <%= if @topic["thumbnail"] != nil do %>

              <img
                class="thumb"
                src="<%= @topic["thumbnail"]["source"] %>"
                alt="<%= @topic["title"] %>"
              >

          <% else %>
              <img class="thumb" src="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcdn1.iconfinder.com%2Fdata%2Ficons%2Fseo-and-development-27%2F128%2Fcase_study_find-512.png&f=1&nofb=1" alt="empty">
          <% end %>

          <div class="info">
              <div class="title"><%= @topic["title"] %></div>
              <div class="desc"><%= @topic["description"] %></div>
          </div>
      </div>
    </div>
    """
  end
end
