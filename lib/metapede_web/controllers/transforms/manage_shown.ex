defmodule MetapedeWeb.Controllers.Transforms.ManageShown do
  # @syntax_colors [number: :yellow, atom: :cyan, string: :green, boolean: :magenta, nil: :magenta]

  def path_helper(id, periods) do
    periods
    |> add_path_indexes([])
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

  def add_path_indexes(periods, index_path) when is_list(periods) do
    for {period, index} <- Enum.with_index(periods) do
      subs = period.sub_time_periods
      new_ind_path = index_path ++ [index]
      [{period.id, new_ind_path}] ++ [add_path_indexes(subs, new_ind_path)]
    end
  end

  def add_path_indexes(_not_loaded, _ind_path), do: []

  def preload_element({_id, []}, period) do
    period
    |> Metapede.Repo.preload([:sub_time_periods, :topic])
    |> update_expand()
    |> mark_children_as_expandable()
  end

  def preload_element({id, path}, period) do
    [index | rest] = path
    picked_subperiod = Enum.at(period.sub_time_periods, index)
    load = preload_element({id, rest}, picked_subperiod)

    # IO.inspect(load, syntax_colors: @syntax_colors, label: "PASS LOAD")

    updated_sub_periods =
      List.replace_at(
        period.sub_time_periods,
        index,
        load
      )

    Map.put(period, :sub_time_periods, updated_sub_periods)
  end

  def mark_children_as_expandable(period) do
    children
     =
      period.sub_time_periods
      |> Enum.map(fn el -> el |> marker end)

    period
      |> Map.put(:sub_time_periods, children)
  end

  def marker(sub_period) do
    with_loaded =
      sub_period
      |> Metapede.Repo.preload([:sub_time_periods, :topic])

    with_loaded
    |> Map.put(:has_sub_periods, length(with_loaded.sub_time_periods) > 0)
  end

  def update_expand(period) do
    period
    |> Map.put(
      :expand,
      !if(Map.has_key?(period, :expand), do: period.expand, else: false)
    )
  end
end
