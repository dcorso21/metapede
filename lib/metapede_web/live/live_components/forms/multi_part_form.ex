defmodule MetapedeWeb.LiveComponents.MultiPartForm do
  use MetapedeWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="multi_part_form">
      <h1 class="multi_title"><%= @form_name %></h1>
      <div class="form_content">
        <div class="outline">
          <div class="steps">
          <%= for { item, index } <- Enum.with_index(@outline_items) do %>
            <%= if index === @outline_step do %>
              <div class="outline_item selected %>">
                <%= "#{index+1}. #{item}" %>
              </div>
            <% else %>
              <div class="outline_item %>">
                <%= "#{index+1}. #{item}" %>
              </div>
            <% end %>
          <% end %>
          </div>
        </div>
        <div class="sub_form">
          <%= live_component @component, @component_options %>
        </div>
      </div>
    </div>
    """
  end
end
