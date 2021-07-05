defmodule MetapedeWeb.Controllers.Transforms.ManageShown do
  def path_helper(id, periods) do
    periods
    |> get_path_info([])
    |> List.flatten()
    |> find_by_id(0, id)
    |> IO.inspect()
  end

  def find_by_id(tuples, index, target_id) do
    {id, path} = Enum.at(tuples, index)

    if(
      id == target_id,
      do: {id, path},
      else: find_by_id(tuples, index + 1, target_id)
    )
  end

  def get_path_info(periods, index_path) when is_list(periods) do
    for {period, index} <- Enum.with_index(periods) do
      subs = period.sub_time_periods
      new_ind_path = [index | index_path]
      [{period.id, new_ind_path} | get_path_info(subs, new_ind_path)]
    end
  end

  def get_path_info(_not_loaded, _ind_path), do: []

  def create_path(path, link), do: path ++ [link]
end
