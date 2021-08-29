defmodule MetapedeWeb.LiveComponents.MultiPartForm do
  use MetapedeWeb, :live_component

  def mount(socket) do
    IO.inspect(socket, label: "The Best")
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div class="multi_part_form">
      <h1><%= @form_name %></h1>
      <div class="form_content">
        <div class="outline">
        <ol>
          <%= for { item, index } <- Enum.with_index(@outline_items) do %>
            <%= if index === 2 do %>
              <li class="outline_item selected %>">
                <%= item %>
              </li>
            <% else %>
              <li class="outline_item %>">
                <%= item %>
              </li>
            <% end %>
          <% end %>
        </ol>
        </div>
        <%= live_component @component, @component_options %>
      </div>
    </div>
    """
  end
end
