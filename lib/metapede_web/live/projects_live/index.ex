defmodule MetapedeWeb.ArchivesLive.Index do
  use MetapedeWeb, :live_view
  alias Metapede.Db.Schemas.Archive
  alias MetapedeWeb.LiveComponents.ArchiveComponent

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(archives: get_archives())}
  end

  def render(assigns) do
    ~L"""
    <h1>Archives</h1>
    <div>
    <%= for archive <- @archives do %>
        <%= live_component ArchiveComponent, archive: archive, id: archive["_id"] %>
    <% end %>
    </div>
    """
  end

  defp get_archives(), do: Archive.get_all() |> Enum.map(&Archive.load/1)
end
