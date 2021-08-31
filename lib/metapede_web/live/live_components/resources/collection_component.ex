defmodule MetapedeWeb.LiveComponents.Resources.CollectionComponent do
  use MetapedeWeb, :live_component
  alias MetapedeWeb.LiveComponents.ArchiveComponent
  alias MetapedeWeb.LiveComponents.CreateArchiveForm

  def mount(socket) do
    {:ok, socket |> assign(view: :default)}
  end

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(archives: assigns.resource["archives"])
     |> assign(current_page: assigns.current_page)}
  end

  def render(assigns) do
    ~L"""
    <button phx-target="<%= @myself %>" phx-click="create">Create</button>
    <%= if length(@archives) === 0 do %>
      <div>No Archives yet</div>
    <% end %>

    <%= if @view === :create do %>
        <%= live_modal @socket, CreateArchiveForm,
          id: :create_archive_form,
          return_to: @current_page %>
    <% end %>

    <%= for archive <- @archives do %>
        <%= live_component ArchiveComponent,
          display_mode: "embed",
          archive: archive,
          expand_component: false,
          return_to: Routes.archives_index_path(@socket, :main),
          id: archive["_id"] %>
    <% end %>
    """
  end

  def handle_event("create", _, socket) do
    {:noreply, socket |> assign(view: :create)}
  end
end
