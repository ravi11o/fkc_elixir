defmodule FkcElixir.Utils do
  @months %{
    1 => "Jan",
    2 => "Feb",
    3 => "March",
    4 => "April",
    5 => "May",
    6 => "June",
    7 => "July",
    8 => "Aug",
    9 => "Sept",
    10 => "Oct",
    11 => "Nov",
    12 => "Dec"
  }

  def format_date_time(date) do
    current_year = Date.utc_today().year

    {{year, month, day}, {hour, minute, _}} = NaiveDateTime.to_erl(date)

    "#{@months[month]} #{day} #{if year != current_year, do: "#{year}, ", else: " "} at #{hour}:#{minute}"
  end
end
