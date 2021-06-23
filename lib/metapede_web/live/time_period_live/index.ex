defmodule MetapedeWeb.TimePeriodLive.Index do
  use MetapedeWeb, :live_view
  alias Metapede.TimelineContext.TimePeriodContext
  alias Metapede.Collection
  # alias Metapede.Collection.Topic
  alias MetapedeWeb.Controllers.Transforms.WikiTransforms

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(time_periods: TimePeriodContext.list_time_periods())
     |> assign(new_topic: %{})}
  end

  def render(assigns) do
    ~L"""
    <%= if @live_action in [:search] do %>
    <%= live_modal @socket, MetapedeWeb.LiveComponents.SearchFormComponent,
        id: :search_form,
        return_to: Routes.time_period_index_path(@socket, :main) %>
    <% end %>

    <%= if @live_action in [:confirm] do %>
    <%= live_modal @socket, MetapedeWeb.LiveComponents.TimePeriod.CreateForm,
        id: :create_form,
        new_topic: @new_topic,
        return_to: Routes.time_period_index_path(@socket, :main) %>
    <% end %>

    <%= if @live_action == :confirm do %>
        <h1>Confirm Please</h1>
    <% end %>


    <h1>Time periods</h1>
    <div>
    <%= for period <- @time_periods do %>
        <div>
            <strong>
            <%= period.topic.title %>
            </strong>
        </div>
        <div>
        <em>
        <%= period.topic.description %>
        </em>
        </div>
        <div><%= period.start_datetime %> - <%= period.end_datetime %></div>
        <br>
        <br>

    <% end %>
    <br>
    <br>
    <br>
    </div>

    <div><%= live_patch "Add New Time Period", to: Routes.time_period_index_path(@socket, :search) %></div>
    <button phx-click="delete_all">Delete All</button>
    """
  end

  def handle_params(%{"id" => id}, _url, socket) do
    new_topic = Collection.get_topic!(id)

    {:noreply,
     socket
     |> assign(new_topic: new_topic)}
  end

  def handle_params(_params, _url, socket), do: {:noreply, socket}

  def handle_event("delete_all", _, socket) do
    Metapede.Repo.delete_all(Metapede.Timeline.TimePeriod)

    {:noreply,
     socket
     |> assign(time_periods: TimePeriodContext.list_time_periods())}
  end

  def handle_event("send_topic", %{"data" => selected_topic}, socket) do
    data =
      Poison.decode!(selected_topic)
      |> WikiTransforms.transform_wiki_data()

    IO.puts(inspect(data))

    # {:noreply, socket}
    case Collection.create_topic(data) do
      {:ok, new_topic} ->
        {:noreply,
         socket
         |> put_flash(:info, "Topic created successfully")
         |> assign(:new_topic, new_topic)
         |> push_redirect(
           to: Routes.time_period_index_path(socket, :confirm, new_topic.id, [new_topic])
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
