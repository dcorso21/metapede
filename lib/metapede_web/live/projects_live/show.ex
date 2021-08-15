defmodule MetapedeWeb.ProjectsLive.Show do
  use MetapedeWeb, :live_view
  alias Metapede.Db.Schemas.Project
  alias Metapede.Db.Schemas.Topic

  def handle_params(params, _url, socket) do
    tp = Topic.find_one_by(%{title: params["id"]})

    pr =
      Project.find_one_by(%{topic_id: tp["_id"]})
      |> Project.load()

    {:noreply, socket |> assign(project: pr)}
  end

  def render(assigns) do
    ~L"""
    <img src="<%= @project["topic"]["thumbnail"] %>">
    <h1><%= @project["topic"]["title"] %></h1>
    <div>
    <%= inspect @project %>
    </div>

    <%= for resource <- @project["resources"] do %>
      <%= live_component MetapedeWeb.LiveComponents.ResourceComponent,
          resource: resource,
          id: resource["_id"] %>
    <% end %>
    """
  end
end
