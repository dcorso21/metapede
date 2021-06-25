defmodule MetapedeWeb.TimePeriodLive.Show do
  use MetapedeWeb, :live_view
  alias Metapede.Repo
  alias Metapede.Collection
  alias Metapede.Collection.Topic
  alias MetapedeWeb.Controllers.Transforms.WikiTransforms

  def handle_params(%{"id" => id}, _url, socket) do
    tp = Metapede.TimelineContext.TimePeriodContext.get_time_period!(id)
    {:noreply, socket |> assign(time_period: tp)}
  end

  def render(assigns) do
    ~L"""
    <div><%= live_redirect "Back", to: Routes.time_period_index_path(@socket, :main) %></div>
    <%= if @time_period.topic.thumbnail != nil do %>
        <img src=<%= @time_period.topic.thumbnail %>>
    <% end %>
    <h2>
        <%= @time_period.topic.title %>
    </h2>
    <div>
        <em>
            <%= @time_period.topic.description %>
        </em>
    </div>
    <div>
    id:
            <%= @time_period.id %>
    </div>

    <div>
      <%= inspect( @time_period ) %>
    </div>
    """
  end

  def handle_event("send_topic", %{"data" => selected_topic}, socket) do
    sub_topic =
      Poison.decode!(selected_topic)
      |> WikiTransforms.transform_wiki_data()

    existing_ids = Collection.check_for_page_id(sub_topic["page_id"])

    case existing_ids do
      [] ->
        IO.puts("New")
        params = get_topic_info(sub_topic, nil, :new)
        test_add(params, socket)

      [id] ->
        IO.puts("Existing")
        params = get_topic_info(nil, id, :existing)
        test_add(params, socket)
    end
  end

  defp test_add(new_topic, parent_object, assoc_as_atom, assoc_func, socket) do
    parent_object
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(assoc_as_atom, assoc_func.(new_topic))
    |> Repo.update!()

    {:noreply,
     socket
     |> put_flash(:info, "Subtopic Added")
     |> push_redirect(to: Routes.topic_show_path(socket, :show, socket.assigns.topic))}
  end

  defp test_add(new_topic, socket) do
    parent_topic = socket.assigns.topic

    parent_topic
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:sub_topics, [new_topic | parent_topic.sub_topics])
    |> Repo.update!()

    {:noreply,
     socket
     |> put_flash(:info, "Subtopic Added")
     |> push_redirect(to: Routes.topic_show_path(socket, :show, socket.assigns.topic))}
  end

  defp get_topic_info(_params, id, :existing), do: Collection.get_topic!(id)
  defp get_topic_info(params, _id, :new), do: Topic.changeset(%Topic{}, params)
end
