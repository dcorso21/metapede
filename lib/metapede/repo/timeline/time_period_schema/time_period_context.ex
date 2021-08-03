defmodule Metapede.TimelineContext.TimePeriodContext do
  import Ecto.Query, warn: false
  alias Metapede.Repo
  alias Metapede.Timeline.TimePeriodSchema.TimePeriod
  alias Metapede.Timeline.DatetimeOps
  alias Metapede.TopicSchema.TopicContext
  alias Metapede.Utils

  @preload [:topic, :events, :parent_time_periods, :sub_time_periods]

  def seed_time_period(time_period) do
    topic_info =
      time_period.title
      |> Metapede.WikiConnect.search_by_term()
      |> Enum.at(0) # Choose first result
      |> TopicContext.transform_wiki_data()

    time_period_info = %{
      start_datetime:
        time_period.start_datetime
        |> DatetimeOps.create_datetime_from_string(),
      end_datetime:
        time_period.end_datetime
        |> DatetimeOps.create_datetime_from_string()
    }

    create_new_with_topic(time_period_info, topic_info)
  end

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

  def add_sub_period(sub_period, parent_time_period) do
    Utils.add_association(
      sub_period,
      parent_time_period,
      :sub_time_periods,
      fn el -> [el | parent_time_period.sub_time_periods] end
    )
  end
end
