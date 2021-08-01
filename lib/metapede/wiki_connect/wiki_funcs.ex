defmodule Metapede.WikiFuncs do
  @base_url "https://en.wikipedia.org/w/api.php"

  def get_page(page_id) do
    query = "?action=parse&format=json&pageid=#{page_id}&prop=text"
    {:ok, res} = HTTPoison.get(@base_url <> query)
    data = Poison.decode!(res.body)
    data["parse"]["text"]["*"]
  end

 def search_moderate(query) do
    headers = [
      "Accept-Language": "en-US,en;q=0.5",
      Connection: "keep-alive"
    ]

    query_string = URI.encode(query)

    e_url =
      "?action=query&format=json&generator=prefixsearch&prop=pageprops%7Cpageimages%7Cdescription&redirects=&ppprop=displaytitle&piprop=thumbnail&pithumbsize=160&pilimit=6&gpssearch=#{
        query_string
      }&gpsnamespace=0&gpslimit=6"

    HTTPoison.get(@base_url <> e_url, headers)
  end

  def transform_search_moderate(res) do
    #  Get pages from result
    pages = Poison.decode!(res.body)["query"]["pages"]
    #  convert to an array, (empty if no results)
    page_list = if pages == nil, do: [], else: Map.to_list(pages)
    #  The array will have tuples, but we only need the second value
    trans = for {_page_num, info} <- page_list, do: info
    #  Sort by index and return
    Enum.sort(trans, &(&1["index"] < &2["index"]))
  end
end
