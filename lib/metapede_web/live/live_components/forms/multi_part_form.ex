defmodule MetapedeWeb.LiveComponents.MultiPartForm do
  use MetapedeWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="multi_part_form">
      <h1><%= @form_name %></h1>
      <div class="form_content">
        <div class="outline">
        <ol>
          <%= for { item, index } <- Enum.with_index(@outline_items) do %>
            <%= if index === @outline_step do %>
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
