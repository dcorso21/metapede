defmodule MetapedeWeb.LiveComponents.TimePeriod.SubPeriodForms do
  use MetapedeWeb, :live_component
  alias Metapede.CommonSearchFuncs
  alias Metapede.TimelineContext.TimePeriodContext
  alias MetapedeWeb.Controllers.Transforms.DatetimeOps
  # Form types: :confirm, :search, :none

  def render(assigns) do
    ~L"""
    <%# Search Modal %>
    <div id="sub_period_forms">
      <%= if @live_action == :search_sub_period do %>
        <%= live_modal @socket, MetapedeWeb.LiveComponents.SearchFormComponent,
          id: :search_form,
          target: "#sub_period_forms",
          event_name: "click_search_topic",
          return_to: Routes.time_period_show_path(@socket, :main, @time_period)
        %>
      <% end %>

      <%# Create Form Modal %>
      <%= if @live_action == :confirm_sub_period do %>
        <%= live_modal @socket, MetapedeWeb.LiveComponents.TimePeriod.ConfirmForm,
          event_name: "confirmed_period",
          id: :confirm_form,
          new_topic: @new_topic,
          return_to: Routes.time_period_show_path(@socket, :main, @time_period)
        %>
      <% end %>
    </div>
    """
  end

  def handle_event("click_search_topic", %{"topic" => topic}, socket) do
    topic
    |> CommonSearchFuncs.decode_and_format_topic()
    |> CommonSearchFuncs.create_if_new()
    |> CommonSearchFuncs.check_for_existing_time_period()
    |> custom_redirect(socket)
  end

  def handle_event("confirmed_period", params, socket) do
    new_period = %{
      start_datetime: DatetimeOps.make_datetimes(params, "sdt"),
      end_datetime: DatetimeOps.make_datetimes(params, "edt")
    }

    case TimePeriodContext.create_time_period(new_period) do
      {:ok, saved_period} ->
        loaded = Metapede.Repo.preload(saved_period, [:topic])

        resp =
          Metapede.CommonSearchFuncs.add_association(
            socket.assigns.new_topic,
            loaded,
            :topic,
            fn el -> el end
          )

        add_subtopic(resp, socket)

      {:error, message} ->
        IO.inspect(message)

        {:noreply,
         socket
         |> put_flash(:error, "An Error Occurred")
         |> push_redirect(to: Routes.time_period_index_path(socket, :main))}

      resp ->
        IO.inspect(resp)
    end
  end

  def custom_redirect({:has_time_period, topic}, socket), do: adding(topic, socket)

  def custom_redirect({:ok, new_topic}, socket),
    do: patch_for_confirm("Topic created for timeline", new_topic, socket)

  def custom_redirect({:existing, new_topic}, socket),
    do: patch_for_confirm("Topic found", new_topic, socket)

  def patch_for_confirm(message, new_topic, socket) do
    {
      :noreply,
      socket
      |> put_flash(:info, message)
      |> assign(:new_topic, new_topic)
      |> push_patch(
        to:
          Routes.time_period_show_path(
            socket,
            :confirm_sub_period,
            socket.assigns.time_period.id,
            %{"new_topic_id" => new_topic.id}
          )
      )
    }
  end
end
