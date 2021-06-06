defmodule MetapedeWeb.LiveComponents.SearchResultsComponent do
  use MetapedeWeb, :live_component

  def render(assigns) do
    ~L"""
    <div id="search_results">
      <%= if length(@wiki_info) > 0 do %>
        <%= for w_topic <- @wiki_info do %>
          <%= live_component @socket, MetapedeWeb.LiveComponents.WikiTopicCompmonent, topic: w_topic, wiki_base_path: @wiki_base_path %>
        <% end %>
      <% end %>
    </div>
    """
  end
end
