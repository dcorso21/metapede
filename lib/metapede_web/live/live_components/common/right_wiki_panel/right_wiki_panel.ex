defmodule MetapedeWeb.LiveComponents.Common.RightWikiPanel do
  use MetapedeWeb, :live_component

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

  def handle_event("change_page_id", %{"page_id" => page_id}, socket) do
    {:noreply,
     socket
     |> assign(:page_id, page_id)
     |> push_event("ensure_open", %{page_id: page_id})
    }
  end
end
