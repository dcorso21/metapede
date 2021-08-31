defmodule MetapedeWeb.ArchivesLive.ResourcePage do
  use MetapedeWeb, :live_view
  alias Metapede.Db.Schemas.Archive
  alias MetapedeWeb.LiveComponents.ArchiveComponent

  def handle_params(params, _url, socket) do
    {resource_type, schema} = Archive.get_res_name_and_schema(params["id"])

    {:noreply,
     socket
     |> assign(id: params["id"])
     |> assign(
       resource: %{
         "resource_type" => resource_type,
         "data" => schema.load(params["id"]),
         "_id" => params["id"]
       }
     )}
  end

  def render(assigns) do
    ~L"""
    <div>
      <%= live_component ArchiveComponent,
        display_mode: "page",
        archive: @resource,
        expand_component: true,
        return_to: Routes.archives_resource_page_path(@socket, :main, @id),
        id: @id %>
    </div>
    """
  end

  # def render(assigns) do
  #   ~L"""
  #   <div>
  #     Hello
  #   </div>
  #   """
  # end
end
