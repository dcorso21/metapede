defmodule MetapedeWeb.LiveComponents.Resources.TopicComponent do
  use MetapedeWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="topic_component">

      <img src="<%= @topic["thumbnail"] %>">

      <div class="info">
        <div class="title_and_type">
          <div class="title">
            <%= @topic["title"] %>
          </div>

          <div class="res_type">
            <%= @res_type %>
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
