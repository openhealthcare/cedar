defmodule Cedar.StatusController do
  use Cedar.Web, :controller

  plug :action

  def index(conn, _params) do
    # If today's year == the only year, just redirect
    # render conn, "index.html", years: [2015], year: 2015
    redirect conn, to: "/status/2015"
  end

  def live(conn, _params) do
    render conn, "live.html"
  end

  def year(conn, %{"year" => year}) do
    year_i = String.to_integer(year)
    render conn, "index.html", years: [2015], year: String.to_integer(year),
                               months: lookup_months_for_year(year_i)
  end

  def month(conn, %{"year" => year, "month" => month}) do
    year_i = String.to_integer(year)
    render conn, "index.html", years: [2015], year: year_i,
                               months: lookup_months_for_year(year_i),
                               month: String.to_integer(month),
                               days: lookup_days_for_year_month(year_i, String.to_integer(month))
  end

  def day(conn, %{"year" => year, "month" => month, "day" => day}) do
    year_i = String.to_integer(year)

    render conn, "index.html", years: [2015], year: year_i,
                               months: lookup_months_for_year(year_i),
                               month: String.to_integer(month),
                               days: lookup_days_for_year_month(year_i, String.to_integer(month)),
                               day: String.to_integer(day)
  end

  def view_day(conn, %{"year" => year, "month" => month, "day" => day}) do
    year_i = String.to_integer(year)

    render conn, "index.html", years: [2015], year: year_i,
                               months: lookup_months_for_year(year_i),
                               month: String.to_integer(month),
                               days: lookup_days_for_year_month(year_i, String.to_integer(month)),
                               day: String.to_integer(day)
  end


  defp lookup_months_for_year(year) do
    logdir = Application.get_env(:auditor, :location)
    lookup_for_path("#{Path.join(logdir, to_string year)}/*")
  end

  defp lookup_days_for_year_month(year, month) do
    logdir = Application.get_env(:auditor, :location)
    lookup_for_path(Path.join(logdir, "#{to_string(year)}/#{to_string(month)}/*" ))
  end

  defp lookup_for_path(path) do
    Enum.map Path.wildcard(path), fn(x) ->
      String.split(x, "/")
      |> Enum.reverse
      |> hd
      |> String.to_integer
    end
  end


end
