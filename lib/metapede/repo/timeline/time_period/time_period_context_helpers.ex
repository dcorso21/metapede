defmodule Metapede.TimelineContext.TimelineContextHelpers do
  # alias Metapede.TopicSchema.Topic
  alias Metapede.TopicSchema.TopicContext

  @type given_topic_info :: %{
          title: binary(),
          description: binary(),
          page_id: binary(),
          thumbnail: binary()
        }

  @type given_time_period_info :: %{
          start_datetime: binary(),
          end_datetime: binary()
        }

  @spec create_time_period(given_topic_info, given_time_period_info) :: any
  def create_time_period(topic_info, time_period_info) do
    topic_info
    |> TopicContext.create_or_pull_topic()
    |> TopicContext.check_if_has_time_period()
    |> associate_time_period(time_period_info)
  end

  def associate_time_period({:existing, topic}, _time_period_info) do
    Metapede.Timeline.TimePeriodSchema.TimePeriodContext
    topic.time_period.id
  end
end
