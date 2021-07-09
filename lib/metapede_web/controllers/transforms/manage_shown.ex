defmodule MetapedeWeb.Controllers.Transforms.ManageShown do
  def path_helper(id, periods) do
    periods
    |> get_path_info([])
    |> IO.inspect(label: "path_info")
    |> List.flatten()
    |> IO.inspect(label: "flattened")
    |> find_by_id(0, id)
    |> IO.inspect(label: "find_by_id")
    |> preload_element(%{sub_time_periods: periods})
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
      new_ind_path = index_path ++ [index]
      [{period.id, new_ind_path}] ++ [get_path_info(subs, new_ind_path)]
    end
  end

  def get_path_info(_not_loaded, _ind_path), do: []

  def preload_element({_id, []}, period) do
    loaded =
      Metapede.Repo.preload(period, [:sub_time_periods, :topic])
      |> IO.inspect(label: "preloaded")

    Map.put(loaded, :expand, updated_expand(loaded))
    |> Map.put(
      :sub_time_periods,
      Metapede.Repo.preload(loaded.sub_time_periods, [:sub_time_periods, :topic])
    )
  end

  def preload_element({id, path}, period) do
    IO.inspect(path, label: "Pass through preload")
    IO.inspect(period, label: "Period")
    [index | rest] = path
    picked_subperiod = Enum.at(period.sub_time_periods, index)
    load = preload_element({id, rest}, picked_subperiod)

    List.replace_at(
      period.sub_time_periods,
      index,
      load
    )
  end

  def updated_expand(period) do
    !if(Map.has_key?(period, :expand), do: period.expand, else: false)
  end
end
