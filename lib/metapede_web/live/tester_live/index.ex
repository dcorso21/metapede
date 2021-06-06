defmodule MetapedeWeb.TesterLive.Test do
  use MetapedeWeb, :live_view
  alias Metapede.Collection

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(title: "My Searcher")
     |> assign(wiki_info: [])
     |> assign(id: "my_form")
     |> assign(topics: Collection.list_topics())}
  end

  def render(assigns) do
    ~L"""
    <h1><%= @title %></h1>
    <%= live_component @socket, MetapedeWeb.LiveComponents.SearchFormComponent, wiki_info: @wiki_info, id: :search_form %>
    <h1>Internal</h1>
    <%= for topic <- @topics do %>
      <div>
        <span><%= topic.name %></span>
      </div>
    <% end %>
    """
  end

end
