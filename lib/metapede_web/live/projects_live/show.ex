defmodule MetapedeWeb.ArchivesLive.Show do
  use MetapedeWeb, :live_view
  alias Metapede.Db.Schemas.Archive

  def handle_params(params, _url, socket) do
    archive =
      params["id"]
      |> Archive.get_by_id()
      |> Archive.load()

    {:noreply, socket |> assign(archive: archive)}
  end

  def render(assigns) do
    ~L"""
    <img src="<%= @archive["topic"]["thumbnail"] %>">
    <h1><%= @archive["topic"]["title"] %></h1>
    <div>
    <%= inspect @archive %>
    </div>

    """
  end

  # <%= for resource <- @project["resources"] do %>
  #   <%= live_component MetapedeWeb.LiveComponents.ResourceComponent,
  #       resource: resource,
  #       id: resource["_id"] %>
  # <% end %>
end
