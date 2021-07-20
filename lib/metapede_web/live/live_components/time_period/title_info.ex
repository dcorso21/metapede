defmodule MetapedeWeb.LiveComponents.TitleInfo do
  use MetapedeWeb, :live_component

  def render(assigns) do
    ~L"""
    	<div class="timeline_info">
    <%= if @time_period.topic.thumbnail != nil do %>
    	<img src= <%= @time_period.topic.thumbnail %> >
    <% end %>
    <div class="name_and_desc">
    	<h2 class="name">
    		<%= @time_period.topic.title %>
    	</h2>
    	<div class="desc">
    		<%= @time_period.topic.description %>
    	</div>
    </div>
    </div>
    """
  end
end
