alias Metapede.Db.Schemas.Archive

# top = %{
#   "title" => "Socrates",
#   "description" =>  "First Philosopher",
#   "thumbnail" => "456",
#   "page_id" => "123"
# }

archives = [

      %{
        "resource_type" => "time_period",
        "data" => %{
          "topic_seed" => "Aristotle",
          "start_datetime" => "-0200",
          "end_datetime" => "-0200",
          "sub_time_periods" => [
            %{
              "topic_seed" => "Plato",
              "start_datetime" => "2000",
              "end_datetime" => "2021",
              "sub_time_periods" => []
            }
          ]
        }
      },
      %{
        "resource_type" => "event",
        "data" => %{
          "topic_seed" => "Biden",
          "datetime" => "-0200",
        }
      },
]

archives
|> Enum.map(&Archive.submit/1)
|> IO.inspect(label: "seed")
