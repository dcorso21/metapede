defmodule Metapede.Timeline.EventSchema.EventContext do

  import Ecto.Query, warn: false
  alias Metapede.Repo
  alias Metapede.Timeline.EventSchema.Event
  @preload [:topic, :parent_time_periods]

  def list_events() do
    Event
    |> Repo.all()
    |> Repo.preload(@preload)
  end

  def get_event!(id) do
    Event
    |> Repo.get!(id)
    |> Repo.preload(@preload)
  end

  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end
end
