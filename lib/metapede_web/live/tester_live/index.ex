defmodule MetapedeWeb.TesterLive.Test do
  use MetapedeWeb, :live_view
  alias Metapede.Collection

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(title: "My Searcher")
     |> assign(wiki_info: [])
    #  |> assign(wiki_base_path: "https://en.wikipedia.org/wiki/")
     |> assign(topics: Metapede.Collection.list_topics())}
  end

  def render(assigns) do
    ~L"""
    <h1><%= @title %></h1>
    <%= live_component @socket, MetapedeWeb.LiveComponents.SearchFormComponent, wiki_info: @wiki_info %>
    <h1>Internal</h1>
    <%= for topic <- @topics do %>
    <div>
      <span><%= topic.name %></span>
    </div>
    <% end %>
    """
  end

  def handle_event("change", %{"my_form" => %{"query" => ""}}, socket) do
    {:noreply,
     socket
     |> assign(topics: Collection.list_topics())
     |> assign(wiki_info: [])}
  end

  def handle_event("change", %{"my_form" => %{"query" => query}}, socket) do
    case Metapede.WikiFuncs.search_moderate(query) do
      {:ok, response} ->
        my_list = Metapede.WikiFuncs.transform_search_moderate(response)

        {:noreply,
         socket
         |> assign(topics: Collection.search_topics(query))
         |> assign(wiki_info: my_list)}

      {:error, message} ->
        IO.puts(message)
        {:noreply, socket |> assign(topics: Collection.search_topics(query))}
    end
  end

  def handle_event("submit", params, socket) do
    IO.puts(inspect(params))
    {:noreply, socket}
  end
end