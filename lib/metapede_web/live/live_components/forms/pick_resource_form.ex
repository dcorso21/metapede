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
    <h1>Pick Resource</h1>
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
    """
  end
end
