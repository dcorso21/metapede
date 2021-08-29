defmodule MetapedeWeb.LiveComponents.SearchFormComponent do
  use MetapedeWeb, :live_component
  # alias Metapede.TopicSchema.TopicContext
  alias Metapede.WikiConnect
  alias MetapedeWeb.LiveComponents.WikiTopicComponent

  def mount(socket) do
    {:ok,
     socket
     |> assign(:wiki_info, [])}
  end

  # def update(assigns, socket) do
  #   {:ok,
  #    socket
  #    |> assign(:wiki_info, [])
  #    |> assign(:target, assigns.target)
  #    |> assign(:event_name, assigns.event_name)}
  # end

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

      <%= if length(@wiki_info) > 0 do %>
        <%= for w_topic <- @wiki_info do %>
          <%= live_component WikiTopicComponent,
            topic: w_topic,
            target: @target,
            event_name: @event_name
          %>
        <% end %>
      <% end %>

    </div>
    """
  end


  def handle_event("submit", _params, socket), do: {:noreply, socket}

  def handle_event("change", %{"my_form" => %{"query" => ""}}, socket),
    do: {:noreply, assign(socket, wiki_info: [])}

  def handle_event("change", %{"my_form" => %{"query" => query}}, socket),
    do: {:noreply, assign(socket, wiki_info: WikiConnect.search_by_term(query))}
end
