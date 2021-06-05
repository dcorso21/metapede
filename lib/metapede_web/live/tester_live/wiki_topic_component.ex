defmodule MetapedeWeb.TesterLive.WikiTopicCompmonent do
  #   use MetapedeWeb, :live_view
  use MetapedeWeb, :live_component
  #   alias Metapede.Collection

  def render(assigns) do
    ~L"""
    <a
    id="<%= @topic["pageid"] %>"
    href="<%= @wiki_base_path <> String.replace(@topic["title"], " ", "_") %>"
    target="_blank">
    <div class="wiki_topic">
        <%= if Map.get(@topic, "thumbnail") != nil do %>
            <img class="thumb" src="<%= @topic["thumbnail"]["source"] %>" alt="<%= @topic["title"] %>">
        <% else %>
            <img class="thumb" src="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcdn1.iconfinder.com%2Fdata%2Ficons%2Fseo-and-development-27%2F128%2Fcase_study_find-512.png&f=1&nofb=1" alt="empty">
        <% end %>

        <div class="info">
            <div class="title"><%= @topic["title"] %></div>
            <div class="desc"><%= @topic["description"] %></div>
        </div>
    </div>
    </a>
    """
  end
end
