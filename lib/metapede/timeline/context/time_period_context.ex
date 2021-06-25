defmodule Metapede.TimelineContext.TimePeriodContext do
  import Ecto.Query, warn: false
  alias Metapede.Repo
  alias Metapede.Timeline.{TimePeriod}

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
end
