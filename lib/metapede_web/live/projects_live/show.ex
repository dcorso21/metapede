defmodule MetapedeWeb.ArchivesLive.Show do
  use MetapedeWeb, :live_view
  alias Metapede.Db.Schemas.Archive
  alias MetapedeWeb.LiveComponents.ArchiveComponent

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
        id: @archive["_id"] %>
    </div>
    """
  end
end
