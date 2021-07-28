defmodule MetapedeWeb.LiveComponents.TimePeriod.SubPeriodForms do
  use MetapedeWeb, :live_component
  # Form types: :confirm, :search, :none

  def render(assigns) do
    ~L"""
    <%= if @sub_period_form do %>

      <%# Search Modal %>
      <%= if @live_action == :search do %>
        <%= live_modal @socket, MetapedeWeb.LiveComponents.SearchFormComponent,
          event_name: "new_sub_time_period",
          id: :search_form,
          return_to: Routes.time_period_show_path(@socket, :main, @time_period)
        %>
      <% end %>

      <%# Create Form Modal %>
      <%= if @live_action == :confirm do %>
        <%= live_modal @socket, MetapedeWeb.LiveComponents.TimePeriod.CreateForm,
          event_name: "confirmed_period",
          id: :confirm_form,
          new_topic: @new_topic,
          return_to: Routes.time_period_show_path(@socket, :main, @time_period)
        %>
      <% end %>


    <% end %>
    """
  end
end
