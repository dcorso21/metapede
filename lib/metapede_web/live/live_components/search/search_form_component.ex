defmodule MetapedeWeb.LiveComponents.SearchFormComponent do
  use MetapedeWeb, :live_component
  alias Metapede.Collection

  # def mount(_params, _session, socket) do
  #   socket = assign(socket, key: value)
  #   {:ok, socket}
  # end

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(:wiki_info, [])
     |> assign(:event_name, assigns.event_name)}
  end

  def render(assigns) do
    ~L"""
    <div id="form_wrapper">
    <%= form_for :my_form, "#", [phx_change: "change", phx_submit: "submit", autocomplete: "off", phx_target: @myself], fn f -> %>
      <div id="form_elements">
        <%= search_input f, :query %>
        <%= submit "Search" %>
      </div>
    <% end %>
      <%= live_component @socket, MetapedeWeb.LiveComponents.SearchResultsComponent, wiki_info: @wiki_info, event_name: @event_name%>
    </div>
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
