defmodule MetapedeWeb.LiveComponents.SearchFormComponent do
  use MetapedeWeb, :live_component
  alias Metapede.TopicSchema.TopicContext

  def update(assigns, socket) do

    IO.puts("TARGET:")
    IO.inspect(assigns)


    {:ok,
     socket
     |> assign(:wiki_info, [])
     |> assign(:target, assigns.target)
     |> assign(:event_name, assigns.event_name)}
  end

  def render(assigns) do
    ~L"""
    <div id="form_wrapper">
      <h1>Search</h1>

      <%# Input Form %>
      <%= form_for :my_form,
        "#",
        [
          phx_change: "change",
          phx_submit: "submit",
          autocomplete: "off",
          phx_target: @myself
        ],
        fn f -> %>
        <div id="form_elements">
          <%= search_input f, :query, [id: "wiki_search_input"]%>
        </div>
      <% end %>


      <%# Search Results %>
      <%= live_component @socket,
          MetapedeWeb.LiveComponents.SearchResultsComponent,
          wiki_info: @wiki_info,
          target: @target,
          event_name: @event_name
      %>

    </div>
    """
  end

  def handle_event("change", %{"my_form" => %{"query" => ""}}, socket) do
    {:noreply,
     socket
     |> assign(topics: TopicContext.list_topics())
     |> assign(wiki_info: [])}
  end

  def handle_event("change", %{"my_form" => %{"query" => query}}, socket) do
    case Metapede.WikiFuncs.search_moderate(query) do
      {:ok, response} ->
        my_list = Metapede.WikiFuncs.transform_search_moderate(response)

        {:noreply,
         socket
         |> assign(topics: TopicContext.search_topics(query))
         |> assign(wiki_info: my_list)}

      {:error, message} ->
        IO.puts(message)
        {:noreply, socket |> assign(topics: TopicContext.search_topics(query))}
    end
  end

  def handle_event("submit", _params, socket) do
    {:noreply, socket}
  end
end
