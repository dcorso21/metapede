defmodule MetapedeWeb.LiveComponents.ResourceComponent do
  use MetapedeWeb, :live_component

  def render(assigns) do
    ~L"""
    <%= inspect @resource %>
    """
  end
end
