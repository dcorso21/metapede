defmodule MetapedeWeb.TopicLive.TopicComponent do
  use MetapedeWeb, :live_component

  def render(assigns) do
    ~L"""
    <div id="@topic-<%= @topic.id %>" class="topic_card">
        <h3><%= @topic.name %></h3>
        <div><%= @topic.description %></div>
        <div>
            <span><%= live_redirect "Show", to: Routes.topic_show_path(@socket, :show, @topic) %></span>
            <span><%= live_patch "Edit", to: Routes.topic_index_path(@socket, :edit, @topic) %></span>
            <span><%= link "Delete", to: "#", phx_click: "delete", phx_value_id: @topic.id, data: [confirm: "Are you sure?"] %></span>
        </div>
    </div>
    """
  end
end
