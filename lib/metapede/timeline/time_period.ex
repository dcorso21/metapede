
defmodule Metapede.Timeline.TimePeriod do
  use Ecto.Schema
  alias Metapede.Collection.Topic

  schema "time_periods" do
    has_one :topic_info, Topic
    has_many :events, Event
    has_many :time_periods, TimePeriod
    timestamps()
  end

end
