defmodule MetapedeWeb.LiveComponents.ExpandInfo do
  use MetapedeWeb, :live_component



  def render(assigns) do
    ~L"""
    <div>
        Hello There
        <%= inspect(@socket) %>
    </div>
    """
  end
end
