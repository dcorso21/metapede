defmodule MetapedeWeb.LiveComponents.TimePeriod.SubPeriodForms do
  use MetapedeWeb, :live_component
  alias Metapede.TopicSchema.TopicContext

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

  def handle_event("click_search_topic", %{"topic" => wiki_topic}, socket) do
    topic_info = TopicContext.decode_and_format_topic(wiki_topic)

    {:noreply,
     socket
     |> push_patch(
       to:
         Routes.time_period_show_path(
           socket,
           :confirm_sub_period,
           socket.assigns.time_period.id,
           new_topic: topic_info
         )
     )}
  end
end
