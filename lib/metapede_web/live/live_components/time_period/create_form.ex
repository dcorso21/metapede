defmodule MetapedeWeb.LiveComponents.TimePeriod.CreateForm do
  use MetapedeWeb, :live_component
  # alias Metapede.TimelineContext.TimePeriodContext

  def render(assigns) do
    ~L"""
    <div>
        <h1>Confirm the period Creation Please</h1>
        <div>
            Title: <%= @new_topic.title %>
        </div>
        <div>
            Description: <%= @new_topic.description %>
        </div>
        <%= f = form_for Metapede.Timeline.TimePeriod, "#",
          id: "time_period_form",
          autocomplete: "off",
          phx_submit: @event_name %>
        <div id="dateranger" phx-hook="DateRange">
                    <%= text_input f, :start_datetime %>
                    <%= error_tag f, :start_datetime %>
            <span>to</span>
                    <%= text_input f, :end_datetime %>
                    <%= error_tag f, :end_datetime %>
        </div>



        <%= submit "Save", phx_disable_with: "Saving..." %>
        </form>
    </div>
    """
  end
end
