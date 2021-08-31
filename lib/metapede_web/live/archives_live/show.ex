defmodule MetapedeWeb.ArchivesLive.Show do
  use MetapedeWeb, :live_view
  alias Metapede.Db.Schemas.Archive
  alias MetapedeWeb.LiveComponents.ArchiveComponent
  alias MetapedeWeb.LiveComponents.Common.RightWikiPanel

  def handle_params(params, _url, socket) do
    archive =
      params["id"]
      |> Archive.get_by_id()
      |> Archive.load()

    {:noreply, socket |> assign(archive: archive)}
  end

  def render(assigns) do
    ~L"""
    <div>
      <%= live_component ArchiveComponent,
        display_mode: "page",
        archive: @archive,
        expand_component: true,
        return_to: Routes.archives_show_path(@socket, :main, @archive["_id"]),
        id: @archive["_id"] %>
    </div>

    <%= live_component RightWikiPanel,
    id: :right_panel,
    page_id: @archive["data"]["topic"]["page_id"]
    %>
    """
  end
end
