defmodule Metapede.WikiFuncs do
  @base_url "https://en.wikipedia.org/w/api.php"

  def search_light(query) do
    headers = [
      "Accept-Language": "en-US,en;q=0.5",
      Connection: "keep-alive"
    ]

    options = [
      params: [
        action: "opensearch",
        format: "json",
        formatversion: 2,
        search: convert_query_string(query),
        namespace: 0,
        limit: 10
      ]
    ]

    make_wiki_request(headers, options)
  end

  def search_moderate(query) do
    headers = [
      "Accept-Language": "en-US,en;q=0.5",
      Connection: "keep-alive"
    ]

    e_url =
      "?action=query&format=json&generator=prefixsearch&prop=pageprops%7Cpageimages%7Cdescription&redirects=&ppprop=displaytitle&piprop=thumbnail&pithumbsize=160&pilimit=6&gpssearch=#{
        convert_query_string(query)
      }&gpsnamespace=0&gpslimit=6"

    HTTPoison.get(@base_url <> e_url, headers)
  end

  def transform_search_moderate(res) do
    pages = Poison.decode!(res.body)["query"]["pages"]
    trans = for {_page_num, info} <- Map.to_list(pages), do: info
    Enum.sort(trans, &(&1["index"] < &2["index"]))
  end

  defp convert_query_string(query) do
    String.replace(query, " ", "\%20")
  end

  defp make_wiki_request(headers, options) do
    HTTPoison.get(@base_url, headers, options)
  end

  defp transform_search_light(response) do
    res = Poison.decode!(response.body)
    names = Enum.at(res, 1)
    urls = Enum.at(res, 3)
    length = length(names)

    transformed =
      for ind <- 0..length do
        %{
          name: Enum.at(names, ind),
          url: Enum.at(urls, ind)
        }
      end

    transformed
  end
end
