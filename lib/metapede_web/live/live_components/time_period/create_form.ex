defmodule MetapedeWeb.LiveComponents.TimePeriod.CreateForm do
  use MetapedeWeb, :live_component
  alias Metapede.TimelineContext.TimePeriodContext


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
        phx_target: @myself,
        # phx_change: "validate",
        phx_submit: "save" %>

        <div>
            <%= label f, :start_date %>
            <%= text_input f, :start_date %>
            <%= error_tag f, :start_date %>
        </div>

        <div>
            <%= label f, :end_date %>
            <%= text_input f, :end_date %>
            <%= error_tag f, :end_date %>
        </div>


        <%= submit "Save", phx_disable_with: "Saving..." %>
        </form>
    </div>
    """
  end

  def handle_event("save", new_period, socket) do
    case TimePeriodContext.create_time_period(new_period) do
        {:ok, saved_period} ->
            {:noreply, socket}

        {:error, message} ->
            IO.puts(inspect(message))
            {:noreply, socket}
    end
  end

end
