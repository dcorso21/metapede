defmodule Metapede.TimelineContext.TimePeriodContext do
  import Ecto.Query, warn: false
  alias Metapede.Repo
  alias Metapede.Timeline.TimePeriodSchema.TimePeriod
  alias Metapede.TopicSchema.TopicContext
  alias Metapede.Utils

  @preload [:topic, :events, :parent_time_periods, :sub_time_periods]

  def list_time_periods() do
    TimePeriod
    |> Repo.all()
    |> Repo.preload(@preload)
  end

  def get_time_period!(id) do
    TimePeriod
    |> Repo.get!(id)
    |> Repo.preload(@preload)
  end

  def create_time_period(attrs \\ %{}) do
    %TimePeriod{}
    |> TimePeriod.changeset(attrs)
    |> Repo.insert()
  end

  def update_time_period(%TimePeriod{} = time_period, attrs) do
    time_period
    |> TimePeriod.changeset(attrs)
    |> Repo.update()
  end

  def delete_time_period(%TimePeriod{} = time_period) do
    Repo.delete(time_period)
  end

  def default_preload(time_period) do
    time_period
    |> Repo.preload(@preload)
  end

  def create_new_with_topic(time_period_info, new_topic_info) do
    {_status, time_period} =
      time_period_info
      |> create_time_period()

    IO.puts("PERIOD")

    time_period
    |> default_preload()
    |> IO.inspect()

    IO.puts("TOPIC")

    {_status, topic} =
      new_topic_info
      |> TopicContext.create_or_pull()
      |> IO.inspect()

    Utils.add_association(
      topic,
      time_period |> default_preload(),
      :topic,
      fn el -> el end
    )
  end
end
