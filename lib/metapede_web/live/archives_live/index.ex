defmodule MetapedeWeb.ArchivesLive.Index do
  use MetapedeWeb, :live_view
  alias Metapede.Db.Schemas.Archive
  alias MetapedeWeb.LiveComponents.ArchiveComponent
  alias MetapedeWeb.LiveComponents.CreateArchiveForm
  alias MetapedeWeb.LiveComponents.Common.RightWikiPanel

  def handle_params(params, _url, socket) do
    {:noreply, socket |> assign(archives: get_archives())}
  end

  def render(assigns) do
    ~L"""
    <h1>Archives</h1>
    <%= live_patch to: Routes.archives_index_path(@socket, :create) do %>
    Create New
    <i class="fas fa-plus"></i>
    <% end %>

    <%= if @live_action === :create do %>
        <%= live_modal @socket, CreateArchiveForm,
          id: :create_archive_form,
          return_to: Routes.archives_index_path(@socket, :main) %>
    <% end %>

    <%= for archive <- @archives do %>
        <%= live_component ArchiveComponent,
          display_mode: "embed",
          archive: archive,
          expand_component: false,
          return_to: Routes.archives_index_path(@socket, :main),
          id: archive["_id"] %>
    <% end %>

    <%= live_component RightWikiPanel,
        id: :right_panel,
        page_id: nil
         %>
    """
  end

  defp get_archives(), do: Archive.get_all() |> Enum.map(&Archive.load/1)
end
