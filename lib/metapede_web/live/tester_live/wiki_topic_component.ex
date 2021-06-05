defmodule MetapedeWeb.TesterLive.WikiTopicCompmonent do
  #   use MetapedeWeb, :live_view
  use MetapedeWeb, :live_component
  #   alias Metapede.Collection

  def render(assigns) do
    ~L"""
    <div>
        <%= if Map.get(@topic, "thumbnail") != nil do %>
            <img src="<%= @topic["thumbnail"]["source"] %>" alt="#">
        <% end %>
        <div><%= @topic["title"] %></div>
        <div><%= @topic["description"] %></div>
    </div>
    """
  end
end
