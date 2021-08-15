defmodule MetapedeWeb.ProjectsLive.Index do
  use MetapedeWeb, :live_view
  alias Metapede.Db.Schemas.Project
  alias Metapede.Db.Schemas.Topic

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(projects: load_projects())}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Projects</h1>
    <div>
      <%= for project <- @projects do %>
        <%= live_component MetapedeWeb.LiveComponents.ProjectComponent, project: project, id: project["_id"] %>
      <% end %>
    </div>
    """
  end

  defp load_projects() do
    Project.get_all()
    |> Enum.map(&Topic.load_topic/1)
  end
end
