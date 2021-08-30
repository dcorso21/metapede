defmodule MetapedeWeb.LiveComponents.PickResourceForm do
  use MetapedeWeb, :live_component

  @resources [
    %{
      display_name: "Time Period",
      description: "A resource for conveying timelines",
      value: "time_period"
    },
    %{
      display_name: "Event",
      description: "A resource for events",
      value: "event"
    }
  ]

  def mount(socket) do
    {:ok, socket |> assign(resources: @resources)}
  end

  def render(assigns) do
    ~L"""
    <div class="pick_resource_form">
      <h1 class="sub_form_title"><%= @form_title %></h1>
      <div class="resource_options">
      <%= for resource <- @resources do %>
        <div class="resource_option"
            phx-click="<%= @event_name %>"
            phx-target="<%= @target %>"
            phx-value-resource = "<%= resource.value %>"
        >
          <div class="name"><%= resource.display_name %></div>
          <div class="description"><%= resource.description %></div>
        </div>
      <% end %>
      </div>
    </div>
    """
  end
end
