defmodule MetapedeWeb.TimePeriodLive.Show do
  use MetapedeWeb, :live_view
  alias Metapede.CommonSearchFuncs
  alias Metapede.TimelineContext.TimePeriodContext

  def handle_params(%{"id" => id, "new_assoc_id" => assoc_id} = params, _url, socket) do
    tp = TimePeriodContext.get_time_period!(id)
    assoc_topic = Metapede.Collection.get_topic!(assoc_id)

    {:noreply,
     socket
     |> assign(time_period: tp)
     |> assign(new_topic: assoc_topic)}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    tp = TimePeriodContext.get_time_period!(id)

    {:noreply,
     socket
     |> assign(time_period: tp)
     |> assign(new_topic: nil)}
  end

  def handle_event("new_sub_time_period", %{"topic" => topic}, socket) do
    topic
    |> CommonSearchFuncs.decode_and_format_topic()
    |> CommonSearchFuncs.create_if_new()
    |> CommonSearchFuncs.check_for_existing_time_period()
    |> custom_redirect(socket)
  end

  def handle_event("confirmed_period", %{"Elixir.Metapede.Timeline.TimePeriod" => new_period}, socket) do
    case TimePeriodContext.create_time_period(new_period) do
      {:ok, saved_period} ->
        loaded = Metapede.Repo.preload(saved_period, [:topic])

        Metapede.CommonSearchFuncs.add_association(
          socket.assigns.new_topic,
          loaded,
          :topic,
          fn el -> el end
        )

        {:noreply,
         socket
         |> put_flash(:info, "New Time Period Created")
         |> push_redirect(to: Routes.time_period_index_path(socket, :main))}

      {:error, message} ->
        IO.puts(inspect(message))

        {:noreply,
         socket
         |> put_flash(:error, "An Error Occurred")
         |> push_redirect(to: Routes.time_period_index_path(socket, :main))}
    end
  end

  def custom_redirect({:ok, new_topic}, socket) do
    {
      :noreply,
      socket
      |> put_flash(:info, "Topic created for timeline")
      |> assign(:new_topic, new_topic)
      |> push_redirect(
        to:
          Routes.time_period_show_path(
            socket,
            :confirm,
            socket.assigns.time_period.id,
            new_topic.id
          )
      )
    }
  end

  def custom_redirect({:existing, new_topic}, socket) do
    {
      :noreply,
      socket
      |> put_flash(:info, "Topic found")
      |> assign(:new_topic, new_topic)
      |> push_redirect(
        to:
          Routes.time_period_show_path(
            socket,
            :confirm,
            socket.assigns.time_period.id,
            new_topic.id
          )
      )
    }
  end

  def custom_redirect({:has_time_period, topic}, socket), do: adding(topic, socket)

  def adding(topic, socket) do
    topic.time_period
    |> block_self_reference(socket)
    |> add_to_subtopics(socket)

    {
      :noreply,
      socket
      |> put_flash(:info, "Sub Time Period Added: #{topic.title}")
      |> push_redirect(
        to: Routes.time_period_show_path(socket, :show, socket.assigns.time_period)
      )
    }
  end

  def block_self_reference(time_period, socket) do
    if time_period.id == socket.assigns.time_period.id do
      {:self, nil}
    else
      {:not_self, time_period}
    end
  end

  def add_to_subtopics({:self, _time_period}, _socket), do: nil

  def add_to_subtopics({:not_self, time_period}, socket) do
    CommonSearchFuncs.add_association(
      time_period,
      socket.assigns.time_period,
      :sub_time_periods,
      fn el ->
        [el | socket.assigns.time_period.sub_time_periods]
      end
    )
  end
end
