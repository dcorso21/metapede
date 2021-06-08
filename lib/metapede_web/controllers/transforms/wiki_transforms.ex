defmodule MetapedeWeb.Controllers.Transforms.WikiTransforms do

  def transform_wiki_data(data) do
    data
    |> Map.take(["title", "description", "thumbnail"])
    |> Map.put("page_id", data["pageid"])
    |> Map.put("thumbnail", pull_url(data))
  end

  defp pull_url(%{"thumbnail" => details}), do: details["source"]
  defp pull_url(_), do: nil

end
