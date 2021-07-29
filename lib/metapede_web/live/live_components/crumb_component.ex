
defmodule MetapedeWeb.LiveComponents.Crumb do
  use MetapedeWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="crumb">
    <span>
    <%= live_patch @crumb["name"],
      to: Routes.time_period_show_path(@socket, :main, @crumb["id"]),
      phx_click: "reset_breadcrumbs" <> Integer.to_string(@index)
    %>
    </span>
    </div>
    <div class="caret">></div>
    """
  end
end
