defmodule MetapedeWeb.LiveComponents.WikiContent do
  use MetapedeWeb, :live_component

  def mount(socket) do
    {:ok, socket |> assign(wiki_loaded: false)}
  end

  def update(assigns, socket) do
    socket =
      socket
      |> assign(:wiki_content, nil)
      |> assign(:page_id, assigns.page_id)

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div>
    <button phx-click="toggle_info" phx-target="<%= @myself %>">Load Page</button>
        <%= if @wiki_loaded do %>
            <%= raw(@wiki_content) %>
        <% end %>
    </div>
    """
  end

  def handle_event("toggle_info", _, socket) do
    toggle = if(socket.assigns.wiki_loaded, do: false, else: true)

    info =
      if(socket.assigns.wiki_content,
        do: socket.assigns.wiki_content,
        else: Metapede.WikiFuncs.get_page(socket.assigns.page_id)
      )

    {:noreply, assign(socket, wiki_loaded: toggle, wiki_content: info)}
  end
end
