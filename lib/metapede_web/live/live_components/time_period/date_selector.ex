defmodule MetapedeWeb.LiveComponents.TimePeriod.DateSelectorComponent do
  use MetapedeWeb, :live_component

  def render(assigns) do
    ~L"""
    <input type="text" name="year" value=""
           placeholder="Year" />
    <select multiple size="3">
        <option selected>C.E.</option>
        <option>B.C.E</option>
    </select>
    <input type="text" name="month" value=""
           placeholder="Month" />
    <input type="text" name="day" value=""
           placeholder="Day" />
    """
  end
end
