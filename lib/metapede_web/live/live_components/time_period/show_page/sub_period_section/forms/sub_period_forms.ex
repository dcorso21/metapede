defmodule MetapedeWeb.LiveComponents.TimePeriod.SubPeriodForms do
  use MetapedeWeb, :live_component
  alias Metapede.CommonSearchFuncs
  alias MetapedeWeb.LiveComponents.TimePeriod.ConfirmForm
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

      <%# Confirm Form Modal %>
      <%= if @live_action == :confirm_sub_period do %>
        <%= live_modal @socket, MetapedeWeb.LiveComponents.TimePeriod.ConfirmForm,
          event_name: "confirmed_period",
          id: :confirm_form,
          new_topic: @new_topic,
          parent_time_period: @time_period,
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

  def custom_redirect({:has_time_period, topic}, socket), do: ConfirmForm.adding(topic, socket)

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
