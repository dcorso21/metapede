defmodule Metapede.Timeline.Event do
  use Ecto.Schema
  alias Metapede.Collection.Topic

  schema "events" do
    has_one :topic, Topic
    field(:datetime, :string)
    timestamps()
  end
end
