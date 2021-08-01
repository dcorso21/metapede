defmodule Metapede.WikiConnect do
  use HTTPoison.Base

  @endpoint "https://en.wikipedia.org/w/api.php"

  def get_page_html_content_by_id(page_id) do
    headers = [
      "Accept-Language": "en-US,en;q=0.5",
      Connection: "keep-alive"
    ]

    query_params = [
      action: "parse",
      format: "json",
      page_id: page_id,
      prop: "text"
    ]

    # TODO: add error handling
    {:ok, res} = HTTPoison.get(@endpoint, headers, params: query_params)
    data = Poison.decode!(res.body)
    data["parse"]["text"]["*"]
  end

  def search_by_term(search_term) do
    headers = [
      "Accept-Language": "en-US,en;q=0.5",
      Connection: "keep-alive"
    ]

    query_params = [
      action: "query",
      format: "json",
      generator: "prefixsearch",
      prop: "pageprops|pageimages|description",
      ppprop: "displaytitle",
      piprop: "thumbnail",
      pithumbsize: "160",
      pilimit: "6",
      gpsnamespace: 0,
      gpslimit: 6,
      gpssearch: search_term
    ]

    res = HTTPoison.get!(@endpoint, headers, params: query_params)

    Poison.decode!(res.body)
    |> transform_search_results()
  end

  defp transform_search_results(res) do
    #  Get pages from result
    pages = res["query"]["pages"]
    #  convert to an array, (empty if no results)
    page_list = if pages == nil, do: [], else: Map.to_list(pages)
    #  The array will have tuples, but we only need the second value
    trans = for {_page_num, info} <- page_list, do: info
    #  Sort by index and return
    Enum.sort(trans, &(&1["index"] < &2["index"]))
  end
end
