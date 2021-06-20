defmodule MetapedeWeb.TimePeriodLive.TimePeriods do
  use MetapedeWeb, :live_view
  alias Metapede.TimelineContext.TimePeriodContext
  alias Metapede.Collection
  alias Metapede.Collection.Topic
  alias MetapedeWeb.Controllers.Transforms.WikiTransforms

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(time_periods: TimePeriodContext.list_time_periods())}
  end

  def render(assigns) do
    ~L"""


    <%= if @live_action in [:search] do %>
    <%= live_modal @socket, MetapedeWeb.LiveComponents.SearchFormComponent,
        id: :search_form,
        return_to: Routes.time_period_time_periods_path(@socket, :main) %>
    <% end %>


    <h1>Hello</h1>
    <div>
    <%= inspect(@time_periods) %>
    </div>

    <div><%= live_patch "Add New Time Period", to: Routes.time_period_time_periods_path(@socket, :search) %></div>
    """
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def handle_event("send_topic", %{"data" => selected_topic}, socket) do
    data =
      Poison.decode!(selected_topic)
      |> WikiTransforms.transform_wiki_data()

    IO.puts(inspect(data))

    # {:noreply, socket}
    case Collection.create_topic(data) do
      {:ok, _topic} ->
        {:noreply,
         socket
         |> put_flash(:info, "Topic created successfully")
         |> push_redirect(to: Routes.topic_topics_path(socket, :topics))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
