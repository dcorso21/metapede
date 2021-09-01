defmodule MetapedeWeb.LiveComponents.CollectionForm do
  use MetapedeWeb, :live_component

  # def mount(socket) do
  # end

  # def update(assigns, socket) do
  # end

  def render(assigns) do
    ~L"""
    <h1>Enter Event Info</h1>
      <%= form_for :confirm,
        "#",
        [
          phx_submit: @event_name,
          autocomplete: "off",
          phx_target: @target
        ],
        fn f -> %>
        <%= submit "Create Archive" %>
      <% end %>
    """
  end
end
