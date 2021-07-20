defmodule MetapedeWeb.LiveComponents.ExpandInfo do
  use MetapedeWeb, :live_component

  def mount(socket) do
    if connected?(socket) do
      send(socket.root_pid, {:right_info_pid, self()})
    end

    {:ok, socket |> assign(open: false)}
  end

  def update(assigns, socket) do
    socket =
      socket
      |> assign(:open, if(assigns.toggle, do: !socket.assigns.open, else: socket.assigns.open))
      |> assign(:page_id, assigns.page_id)

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div
    phx-hook="rightInfoHook"
    id="right_info_wrap"
    phx-update="ignore"
    data-page_id="<%= @page_id %>"
    >
    </div>
    """
  end
end
