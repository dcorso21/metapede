alias Metapede.Db.Schemas.Archive

collection = [
  %{
    "resource_type" => "time_period",
    "data" => %{
      "topic_seed" => "Philosophy",
      "start_datetime" => "-002000",
      "end_datetime" => "2000",
      "sub_time_periods" => [
        %{
          "topic_seed" => "Socrates",
          "start_datetime" => "-000470",
          "end_datetime" => "-000400",
          "sub_time_periods" => []
        },
        %{
          "topic_seed" => "Plato",
          "start_datetime" => "-000420",
          "end_datetime" => "-000370",
          "sub_time_periods" => []
        },
        %{
          "topic_seed" => "Aristotle",
          "start_datetime" => "-000390",
          "end_datetime" => "-000300",
          "sub_time_periods" => []
        }
      ]
    }
  },
  %{
    "resource_type" => "event",
    "data" => %{
      "topic_seed" => "John Lennon",
      "datetime" => "1941"
    }
  }
]

arch = %{
  "resource_type" => "collection",
  "data" => %{
    "archives" => collection,
    "topic_seed" => "Sweden"
  }
}

arch
|> Archive.unload()
|> IO.inspect(label: "seed")
