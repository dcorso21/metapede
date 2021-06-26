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

  def handle_event("send_topic", %{"data" => selected_topic}, socket) do
    sub_topic =
      Poison.decode!(selected_topic)
      |> WikiTransforms.transform_wiki_data()

    existing_ids = Collection.check_for_page_id(sub_topic["page_id"])
    new_topic = get_topic_info(sub_topic, existing_ids)
    add_func = fn el -> [el | socket.assigns.time_period.sub_time_periods] end
    result = add_association(new_topic, socket.assigns.time_period, :sub_time_periods, add_func)
    IO.inspect(result)

    {:noreply,
     socket
     |> put_flash(:info, "Subtopic Added")
     |> push_redirect(to: Routes.topic_show_path(socket, :show, socket.assigns.topic))}
  end

  defp add_association(new_assoc, parent_object, atom_name, assoc_func) do
    parent_object
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(atom_name, assoc_func.(new_assoc))
    |> Repo.update!()
  end

  defp get_topic_info(_params, [id]), do: Collection.get_topic!(id)
  defp get_topic_info(params, []), do: Topic.changeset(%Topic{}, params)
end
