defmodule Metapede.Timeline.Event do
  use Ecto.Schema

  schema "events" do
    # it is associated with a topic
    belongs_to :topic_info, Topic
    field :datetime, :string
    timestamps()
  end
end
