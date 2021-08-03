defmodule Metapede.Timeline.DatetimeOps do

  def make_datetimes(params, prefix) do
    year = params[prefix <> "_year"]
    month = params[prefix <> "_month"] |> get_month_number
    day = params[prefix <> "_day"] #|> ensure_2digits()
    dt = format_datetime([year, month, day])
    IO.puts(dt)
    dt
  end

  def create_datetime_from_string(date_string) do
    date_string
    |> String.split("/")
    |> format_datetime()
  end

  defp format_datetime([day, month, year]), do: NaiveDateTime.from_iso8601!("#{year}-#{month}-#{day}T00:00:00Z")

  # defp ensure_2digits(entry), do: if(String.length(entry) == 1, do: "0#{entry}", else: entry)

  defp get_month_number(month_abbrev) do
    months = %{
      "Jan" => "01",
      "Feb" => "02",
      "Mar" => "03",
      "Apr" => "04",
      "May" => "05",
      "Jun" => "06",
      "Jul" => "07",
      "Aug" => "08",
      "Sep" => "09",
      "Oct" => "10",
      "Nov" => "11",
      "Dec" => "12"
    }

    months[month_abbrev]
  end
end
