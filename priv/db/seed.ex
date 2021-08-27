alias Metapede.Db.Schemas.Archive

archives = [

      %{
        "resource_type" => "time_period",
        "data" => %{
          "topic_seed" => "Aristotle",
          "start_datetime" => "-000200",
          "end_datetime" => "-000300",
          "sub_time_periods" => [
            %{
              "topic_seed" => "Plato",
              "start_datetime" => "-000399",
              "end_datetime" => "-000429",
              "sub_time_periods" => []
            }
          ]
        }
      },
      %{
        "resource_type" => "event",
        "data" => %{
          "topic_seed" => "John Lennon",
          "datetime" => "1941",
        }
      },
]

archives
|> Enum.map(&Archive.submit/1)
|> IO.inspect(label: "seed")
