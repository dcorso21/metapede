defmodule MetapedeWeb.ProjectsLive.Index do
  use MetapedeWeb, :live_view
  alias Metapede.Db.Schemas.Archive

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(archives: load_projects())}
  end

  def render(assigns) do
    ~L"""
    <h1>Projects</h1>
    <div>
    <%= for archive <- @archives do %>
        <%= live_component MetapedeWeb.LiveComponents.ArchiveComponent, project: archive, id: archive["_id"] %>
    <% end %>
    </div>
    """
  end

  defp load_projects() do
    Archive.get_all()
    |> Enum.map(&Archive.load/1)
  end
end
