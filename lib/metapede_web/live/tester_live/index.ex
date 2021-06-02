defmodule MetapedeWeb.TesterLive.Index do
  use MetapedeWeb, :live_view
  alias Metapede.Collection

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(title: "My Searcher")
     |> assign(topics: Metapede.Collection.list_topics())}
  end

  def render(assigns) do
    ~L"""
        <h1><%= @title %></h1>
        <%= form_for :my_form, "#", [phx_change: "change", phx_submit: "submit"], fn f -> %>
            <%= search_input f, :query %>
            <%= submit "Search" %>
        <% end %>
        <%= for topic <- @topics do %>
        <div>
            <span><%= topic.name %></span>
        </div>
        <% end %>
    """
  end

  def handle_event("change", %{"my_form" => %{"query" => ""}}, socket) do
    {:noreply, socket |> assign(topics: Collection.list_topics())}
  end

  def handle_event("change", %{"my_form" => %{"query" => query}}, socket) do
    {:noreply, socket |> assign(topics: Collection.search_topics(query))}
  end

  def handle_event("submit", params, socket) do
    IO.puts(inspect(params))
    {:noreply, socket}
  end
end
