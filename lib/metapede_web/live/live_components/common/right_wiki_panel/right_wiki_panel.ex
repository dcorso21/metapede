defmodule MetapedeWeb.LiveComponents.Common.RightWikiPanel do
  use MetapedeWeb, :live_component

  def mount(socket) do
    if connected?(socket) do
      send(socket.root_pid, {:right_info_pid, self()})
    end

    {:ok, socket |> assign(open: false)}
  end

  def render(assigns) do
    ~L"""
    <div
      phx-hook="rightWikiPanelHook"
      id="right_info_wrap"
      phx-update="ignore"
      data-page_id="<%= @page_id %>"
      data-open="<%= @open %>"
    >
    </div>
    """
  end

  def handle_event("toggle_visible", _, socket) do
    {:noreply, socket |> assign(open: !socket.assigns.open)}
  end
end
