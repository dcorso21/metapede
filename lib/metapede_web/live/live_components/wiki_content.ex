defmodule MetapedeWeb.LiveComponents.WikiContent do
  use MetapedeWeb, :live_component

  def render(assigns) do
    ~L"""
    <div>
    <button phx-click="loadpage" phx-target="<%= @myself %>"></button>
        <%= if @wiki_content do %>
            <%= raw(@wiki_content) %>
        <% end %>
    </div>
    """
  end

  def handle_event("loadpage", _, socket) do
    {:ok, assign(socket, :wiki_content, Metapede.WikiFuncs.get_page(socket.assigns.page_id))}
    {:noreply, socket}
  end
end
