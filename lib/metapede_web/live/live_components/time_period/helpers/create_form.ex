defmodule MetapedeWeb.LiveComponents.TimePeriod.CreateForm do
  use MetapedeWeb, :live_component
  # alias Metapede.TimelineContext.TimePeriodContext

  def render(assigns) do
    ~L"""
    <%= if @new_topic != nil do %>
    <div class="confirm_box">
      <div class="left_form">
          <h1>Confirm the period Creation Please</h1>
          <div>
              Title: <%= @new_topic.title %>
          </div>
          <div>
              Description: <%= @new_topic.description %>
          </div>
          <%= form_for Metapede.Timeline.TimePeriod, "#",
            id: "time_period_form",
            autocomplete: "off",
            phx_submit: @event_name %>

            <div class="date_options">
              <%= live_component @socket, MetapedeWeb.LiveComponents.TimePeriod.DateSelectorComponent, title: "Start Date", prefix: "sdt" %>
              <%= live_component @socket, MetapedeWeb.LiveComponents.TimePeriod.DateSelectorComponent, title: "End Date", prefix: "edt" %>
            </div>

          <%= submit "Save", phx_disable_with: "Saving..." %>
          </form>
      </div>
      <div class="right_page">
      <%= live_component @socket, MetapedeWeb.LiveComponents.WikiContent, page_id: @new_topic.page_id, id: @new_topic.title <> "_page" %>
      </div>
    </div>
    <% end %>
    """
  end
end
