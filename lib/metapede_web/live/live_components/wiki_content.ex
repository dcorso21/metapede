defmodule MetapedeWeb.LiveComponents.WikiContent do
  use MetapedeWeb, :live_component

  def mount(_params, _session, socket) do
    send(self(), {:load_data})
    {:ok, socket}
  end

  def update(assigns, socket) do
    socket =
      socket
      |> assign(:wiki_content, nil)
      |> assign(:page_id, assigns.page_id)

    {:ok, socket}
  end

  def handle_info({:load_data}, socket) do
    {:noreply, assign(socket, :wiki_content, Metapede.WikiFuncs.get_page(socket.assigns.page_id))}
  end

  def render(assigns) do
    ~L"""
    <div>
        <%= if @wiki_content do %>
            <%= raw(@wiki_content) %>
        <% end %>
    </div>
    """
  end
end
