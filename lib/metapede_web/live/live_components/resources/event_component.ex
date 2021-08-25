defmodule MetapedeWeb.LiveComponents.Resources.EventComponent do
  use MetapedeWeb, :live_component

  # def update(assigns, socket) do
  #   {:ok,
  #    socket
  #    |> assign(time_period: assigns.time_period)
  #    |> assign(loaded_sub_periods: assigns.time_period |> initialize_sub_periods)}
  # end

  def render(assigns) do
    ~L"""
    <div>Hello</div>
    """
  end
end
