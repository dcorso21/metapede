defmodule MetapedeWeb.ArchivesLive.Index do
  use MetapedeWeb, :live_view
  alias Metapede.Db.Schemas.Archive
  alias MetapedeWeb.LiveComponents.ArchiveComponent
  alias MetapedeWeb.LiveComponents.SearchFormComponent
  alias MetapedeWeb.LiveComponents.PickResourceForm
  alias MetapedeWeb.LiveComponents.MultiPartForm

  def mount(_params, _session, socket) do
    options = [
      event_name: "new_archive_topic",
      id: :search_form,
      index: 0
    ]

    {:ok,
     socket
     |> assign(create_archive_step_index: 0)
     |> assign(create_component: SearchFormComponent)
     |> assign(create_component_options: options)
     |> assign(archives: get_archives())}
  end

  def render(assigns) do
    ~L"""
    <h1>Archives</h1>
    <%= live_redirect "Create", to: Routes.archives_index_path(@socket, :create) %>

    <%= if @live_action === :create do %>
        <%= live_modal @socket, MultiPartForm,
          id: :create_archive_form,
          form_name: "Create Archive",
          outline_items: ["Pick Topic", "Select Resource Type", "Confirm Info"],
          outline_step: @create_archive_step_index,
          component: @create_component,
          component_options: @create_component_options,
          return_to: Routes.archives_index_path(@socket, :main) %>
    <% end %>

    <%= for archive <- @archives do %>
        <%= live_component ArchiveComponent,
          display_mode: "embed",
          archive: archive,
          expand_component: false,
          id: archive["_id"] %>
    <% end %>
    """
  end

  def handle_event("new_archive_topic", params, socket) do
    options = [
      id: :pick_resource,
      event_name: "pick_resource",
      selected_topic: params["topic"],
      return_to: Routes.archives_index_path(socket, :main),
      index: 1
    ]

    {:noreply,
     socket
     |> assign(:create_component, PickResourceForm)
     |> assign(:create_component_options, options)}
  end

  defp get_archives(), do: Archive.get_all() |> Enum.map(&Archive.load/1)
end
