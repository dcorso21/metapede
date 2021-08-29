defmodule MetapedeWeb.LiveComponents.CreateArchiveForm do
  use MetapedeWeb, :live_component
  alias MetapedeWeb.LiveComponents.SearchFormComponent
  alias MetapedeWeb.LiveComponents.PickResourceForm
  alias MetapedeWeb.LiveComponents.MultiPartForm

  @target "#create_archive_form"

  def mount(socket) do
    options = [
      event_name: "new_archive_topic",
      id: :search_form,
      target: @target
    ]

    {:ok,
     socket
     |> assign(outline_step: 0)
     |> assign(create_component: SearchFormComponent)
     |> assign(create_component_options: options)}
  end

  def render(assigns) do
    ~L"""
    <div id="create_archive_form">
      <%= live_component MultiPartForm,
        id: :create_archive_form,
        form_name: "Create Archive",
        outline_items: ["Pick Topic", "Select Resource Type", "Confirm Info"],
        outline_step: @outline_step,
        component: @create_component,
        component_options: @create_component_options
      %>
    </div>
    """
  end

  def handle_event("new_archive_topic", params, socket) do
    options = [
      id: :pick_resource,
      event_name: "pick_resource",
      selected_topic: params["topic"],
      target: @target
    ]

    {:noreply,
     socket
     |> assign(:outline_step, 1)
     |> assign(:selected_topic, params["topic"])
     |> assign(:create_component, PickResourceForm)
     |> assign(:create_component_options, options)}
  end

  def handle_event("pick_resource", %{"resource" => picked}, socket) do
    {:noreply,
     socket
     |> assign(selected_resource_type: picked)}
  end
end
