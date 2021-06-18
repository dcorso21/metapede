defmodule MetapedeWeb.LiveComponents.WikiContent do
  use MetapedeWeb, :live_component

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
    <button phx-click="loadpage" phx-target="<%= @myself %>">Load Page</button>
        <%= if @wiki_content do %>
            <%= raw(@wiki_content) %>
        <% end %>
    </div>
    """
  end

  def handle_event("loadpage", _, socket) do
    IO.puts "Hello"
    {:noreply, assign(socket, :wiki_content, Metapede.WikiFuncs.get_page(socket.assigns.page_id))}
  end
end
