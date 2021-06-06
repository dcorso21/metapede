defmodule MetapedeWeb.LiveComponents.SearchFormComponent do
  use MetapedeWeb, :live_component
  # needs @socket, wiki_info, wiki_base_path

  def render(assigns) do
    ~L"""
    <div id="form_wrapper">
    <%= form_for :my_form, "#", [phx_change: "change", phx_submit: "submit", autocomplete: "off"], fn f -> %>
      <div id="form_elements">
        <%= search_input f, :query %>
        <%= submit "Search" %>
      </div>
    <% end %>
      <%= live_component @socket, MetapedeWeb.LiveComponents.SearchResultsComponent, wiki_info: @wiki_info%>
    </div>
    """
  end
end
