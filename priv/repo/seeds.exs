# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Metapede.Repo.insert!(%Metapede.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Metapede.TimelineContext.TimePeriodContext
alias Metapede.Timeline.TimePeriodSchema.TimePeriod

tls = [
  %{
    res_type: "TimePeriod",
    title: "Socrates",
    start_datetime: "01/01/1000",
    end_datetime: "01/01/1080",
    sub_time_periods: []
  },
  %{
    res_type: "TimePeriod",
    title: "Aristotle",
    start_datetime: "01/01/1090",
    end_datetime: "01/01/1120",
    sub_time_periods: []
  },
  %{
    res_type: "TimePeriod",
    title: "Plato",
    start_datetime: "01/01/1190",
    end_datetime: "01/01/1220",
    sub_time_periods: []
  }
]

Enum.map(tls, &TimePeriodContext.seed_time_period(&1))
