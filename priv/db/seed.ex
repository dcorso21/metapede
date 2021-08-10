alias Metapede.Db.Schemas.Project

top = %{
  title: "Socrates",
  description: "First Philosopher",
  thumbnail: "456",
  page_id: "123"
}

projects = [
  %{
    topic_seed: "Socrates",
    resources: [
      %{
        res_type: "event",
        info: %{
          topic: top,
          datetime: "-1002"
        }
      },
      %{
        res_type: "time_period",
        info: %{
          topic_seed: "Aristotle",
          start_datetime: "-0200",
          end_datetime: "-0200",
          sub_time_periods: [
            %{
              topic_seed: "Plato",
              start_datetime: "2000",
              end_datetime: "2021",
              sub_time_periods: [
                %{
                  topic_seed: "The_Beatles",
                  start_datetime: "2000",
                  end_datetime: "2021",
                  sub_time_periods: []
                }
              ]
            }
          ]
        }
      },
      %{
        res_type: "time_period",
        info: %{
          topic_seed: "john_lennon",
          start_datetime: "-0400",
          end_datetime: "-0600",
          sub_time_periods: []
        }
      }
    ]
  }
]

projects
|> Enum.map(&Project.submit/1)
|> IO.inspect(label: "seed")
