defmodule MetapedeWeb.LiveComponents.TimePeriodForm do
  use MetapedeWeb, :live_component

  # def mount(socket) do
  # end

  # def update(assigns, socket) do
  # end

  def render(assigns) do
    ~L"""
    <h1>Enter Time Period Info</h1>
      <%= form_for :confirm_resource,
        "#",
        [
          phx_change: "change",
          phx_submit: @event_name,
          autocomplete: "off",
          phx_target: @target
        ],
        fn f -> %>
        <div>
          <label for="start_datetime">Start Datetime</label>
          <input type="text" name="start_datetime"/>
        </div>
        <div>
          <label for="end_datetime">End Datetime</label>
          <input type="text" name="end_datetime"/>
        </div>
      <% end %>
    """
  end
end
