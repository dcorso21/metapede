defmodule MetapedeWeb.LiveComponents.EventForm do
  use MetapedeWeb, :live_component

  # def mount(socket) do
  # end

  # def update(assigns, socket) do
  # end

  def render(assigns) do
    ~L"""
    <h1>Enter Event Info</h1>
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
          <label for="datetime">Datetime</label>
          <input type="text" name="datetime"/>
        </div>
      <% end %>
    """
  end
end
