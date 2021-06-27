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

        <div>
            <%= label f, :start_datetime %>
            <%= text_input f, :start_datetime %>
            <%= error_tag f, :start_datetime %>
        </div>

        <div>
            <%= label f, :end_datetime %>
            <%= text_input f, :end_datetime %>
            <%= error_tag f, :end_datetime %>
        </div>


        <%= submit "Save", phx_disable_with: "Saving..." %>
        </form>
    </div>
    """
  end

  # def handle_event("save", %{"Elixir.Metapede.Timeline.TimePeriod" => new_period}, socket) do
  #   case TimePeriodContext.create_time_period(new_period) do
  #     {:ok, saved_period} ->
  #       Metapede.CommonSearchFuncs.add_association(
  #         socket.assigns.new_topic,
  #         saved_period,
  #         :topic,
  #         fn el -> el end
  #       )

  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "New Time Period Created")
  #        |> push_redirect(to: Routes.time_period_index_path(socket, :main))}

  #     {:error, message} ->
  #       IO.puts(inspect(message))

  #       {:noreply,
  #        socket
  #        |> put_flash(:error, "An Error Occurred")
  #        |> push_redirect(to: Routes.time_period_index_path(socket, :main))}
  #   end
  # end
end
