defmodule MetapedeWeb.LiveComponents.ExpandInfo do
  use MetapedeWeb, :live_component

  def mount(socket) do
    if connected?(socket) do
      send(socket.root_pid, {:right_info_pid, self()})
    end

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div>
      <%= @info %>
    </div>
    """
  end

end
