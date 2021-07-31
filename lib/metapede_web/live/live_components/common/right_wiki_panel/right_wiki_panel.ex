defmodule MetapedeWeb.LiveComponents.Common.RightWikiPanel do
  use MetapedeWeb, :live_component

  def mount(socket) do
    if connected?(socket) do
      send(socket.root_pid, {:right_info_pid, self()})
    end

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div
      phx-hook="rightWikiPanelHook"
      id="right_panel_wrap"
      phx-update="ignore"
      data-page_id="<%= @page_id %>"
    >
    </div>
    """
  end
end
