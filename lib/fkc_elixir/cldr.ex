defmodule FkcElixir.Cldr do
  use Cldr,
    locales: ["en", "fr", "ja"],
    providers: [Cldr.Number, Cldr.Calendar, Cldr.DateTime]

  def format_date_time(date) do
    time = NaiveDateTime.diff(date, NaiveDateTime.utc_now())
    {:ok, result} = FkcElixir.Cldr.DateTime.Relative.to_string(time)
    result
  end
end
