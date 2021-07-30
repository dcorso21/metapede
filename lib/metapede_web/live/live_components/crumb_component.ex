defmodule MetapedeWeb.LiveComponents.Crumb do
  use MetapedeWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="crumb">
        <span>
            <%= live_patch @crumb["name"],
                to: Routes.time_period_show_path(@socket, :main, @crumb["id"]),
                phx_click: "clicked_breadcrumb_" <> Integer.to_string(@index),
                phx_target: @target
            %>
        </span>
    </div>
    <div class="caret">></div>
    """
  end
end
