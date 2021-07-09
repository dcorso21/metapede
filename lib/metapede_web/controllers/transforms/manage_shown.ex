defmodule MetapedeWeb.Controllers.Transforms.ManageShown do

  @syntax_colors [number: :yellow, atom: :cyan, string: :green, boolean: :magenta, nil: :magenta]

  def path_helper(id, periods) do
    periods
    |> get_path_info([])
    |> List.flatten()
    |> find_by_id(0, id)
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
    period
    |> Metapede.Repo.preload([:sub_time_periods, :topic])
    |> Map.put(:expand, updated_expand(period))
    |> prel_el()
  end

  def preload_element({id, path}, period) do
    [index | rest] = path
    picked_subperiod = Enum.at(period.sub_time_periods, index)
    load = preload_element({id, rest}, picked_subperiod)

    IO.inspect(load, syntax_colors: @syntax_colors, label: "PASS LOAD")

    List.replace_at(
      period.sub_time_periods,
      index,
      load
    )
  end

  def prel_el(period) do
    Map.put(
      period,
      :sub_time_periods,
      Metapede.Repo.preload(period.sub_time_periods, [:sub_time_periods, :topic])
    )
  end

  def updated_expand(period),
    do: !if(Map.has_key?(period, :expand), do: period.expand, else: false)
end
