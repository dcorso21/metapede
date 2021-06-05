defmodule MetapedeWeb.TesterLive.Index do
  use MetapedeWeb, :live_view
  alias Metapede.Collection

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(title: "My Searcher")
     |> assign(wiki_info: [])
     |> assign(topics: Metapede.Collection.list_topics())}
  end

  def handle_event("change", %{"my_form" => %{"query" => ""}}, socket) do
    {:noreply,
     socket
     |> assign(topics: Collection.list_topics())
     |> assign(wiki_info: [])}
  end

  def handle_event("change", %{"my_form" => %{"query" => query}}, socket) do
    new_query = String.replace(query, " ", "\%20")

    url =
      "https://en.wikipedia.org/w/api.php?action=opensearch&format=json&formatversion=2&search=#{
        new_query
      }&namespace=0&limit=10"

    case HTTPoison.get(url) do
      {:ok, response} ->
        res = Poison.decode!(response.body)
        names = Enum.at(res, 1)
        urls = Enum.at(res, 3)
        my_list = transform_wiki_response(names, urls)

        IO.puts(inspect(my_list))

        {:noreply,
         socket
         |> assign(topics: Collection.search_topics(query))
         |> assign(wiki_info: my_list)}

      {:error, message} ->
        IO.puts(message)
        {:noreply, socket |> assign(topics: Collection.search_topics(query))}
    end
  end

  def handle_event("submit", params, socket) do
    IO.puts(inspect(params))
    {:noreply, socket}
  end

  defp transform_wiki_response(names, urls) do
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
