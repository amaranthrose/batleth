defmodule BatlethServer.PageController do
  use BatlethServer.Web, :controller
  use Timex

  @per_page 10

  def index(conn, params) do
    IO.inspect(params)
    filter_to = get_date(params["filter_to"])
    filter_from = get_date(params["filter_from"])
    date_end = filter_to || BatlethServer.Time.week_ago
    date_start = filter_to || BatlethServer.Time.(Date.subtract(Time.to_timestamp(Date.now, 7, :days)))
    last = get_last_record
    records_list = GenServer.call(:base, {:get, date_start, date_end})
    IO.inspect(records_list)
    {pages_num, current_page, paged} = case records_list do
    [list] ->prepare_pagination(records_list, params)
    _ -> {1,1,[]}
    end
    render conn, "index.html", records: paged, last: last, pages_num: pages_num, current_page: current_page
  end

  def filter(conn, %{"filter" => filter}) do
    filter_from = DateFormat.parse(filter["from"], "%d %B, %Y", :strftime)

    IO.inspect(filter_from)
    redirect conn, to: "/"#, filter_from: from, filter_to: to
  end



  defp get_date(param) do
    #case param do

      #end
      nil
  end

  #Returns last record from database.
  #If database empty, returns %{pr: "Unknown"} map
  defp get_last_record do
    case GenServer.call(:base, {:get, :last}) do
      a when is_map(a) -> a
      _ -> %{pr: "Unknown"}
    end
  end

  #Prepares pagination based on records_list
  defp prepare_pagination(records_list, params) do
    case records_list do
      a when is_list(a) ->
        pages_num = count_pages_num(records_list)
        current_page = get_current_page(params, pages_num)
        paged = get_page_from_table(records_list, current_page)
        {pages_num, current_page, paged}
      _ -> {1,1,[]}
    end
  end

  #Returns current_page param or 1 if current_page param is not found / bad
  defp get_current_page(params, pages_num) do
    case params["current_page"] do
      nil -> 1
      _ -> case Integer.parse(params["current_page"]) do
        {c, _} when c <= pages_num and c > 0 -> c
        _ -> 1
      end
    end
  end

  #Counts total number of pages in records_list
  defp count_pages_num(records_list) do
    Enum.count(records_list) / @per_page |> Float.ceil |> trunc
  end

  #Gets current page from paginated table
  defp get_page_from_table(records_list, current_page) do
    records_list
    |> Enum.reverse
    |> BatlethServer.Pagination.get_paginated_list(current_page-1, @per_page)
  end

end
