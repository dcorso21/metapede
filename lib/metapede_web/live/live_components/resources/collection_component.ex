defmodule MetapedeWeb.LiveComponents.Resources.CollectionComponent do
  use MetapedeWeb, :live_component
  alias MetapedeWeb.LiveComponents.ArchiveComponent

  # def mount(socket) do
  # end

  def update(assigns, socket) do
    {:ok, socket |> assign(archives: assigns.resource["archives"])}
  end

  def render(assigns) do
    ~L"""
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
end
