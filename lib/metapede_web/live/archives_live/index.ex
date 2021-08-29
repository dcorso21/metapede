defmodule MetapedeWeb.ArchivesLive.Index do
  use MetapedeWeb, :live_view
  alias Metapede.Db.Schemas.Archive
  alias MetapedeWeb.LiveComponents.ArchiveComponent
  # alias MetapedeWeb.LiveComponents.SearchFormComponent
  # alias MetapedeWeb.LiveComponents.PickResourceForm
  # alias MetapedeWeb.LiveComponents.MultiPartForm
  alias MetapedeWeb.LiveComponents.CreateArchiveForm

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(archives: get_archives())}
  end

  def render(assigns) do
    ~L"""
    <h1>Archives</h1>
    <%= live_redirect "Create", to: Routes.archives_index_path(@socket, :create) %>

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
          id: archive["_id"] %>
    <% end %>
    """
  end


  defp get_archives(), do: Archive.get_all() |> Enum.map(&Archive.load/1)
end
