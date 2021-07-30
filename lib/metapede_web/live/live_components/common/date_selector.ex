defmodule MetapedeWeb.LiveComponents.TimePeriod.DateSelectorComponent do
  use MetapedeWeb, :live_component

  def render(assigns) do
    months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ]

    ~L"""
    <div class="date_selector">
        <h4 class="title"><%= @title %></h4>
        <div class="year">
            <input type="text" name="<%= @prefix <> "_year" %>"
                placeholder="Year" />
            <select name="<%= @prefix <> "_era" %>">
                <option selected>C.E.</option>
                <option>B.C.E</option>
            </select>
        </div>

        <div class="month" name="<%= @prefix <> "_month" %>">
            <select name="<%= @prefix <> "_month" %>">
                <option value="Jan" selected>Month (empty)<option>
                <%= for month <- months do %>
                    <option><%= month %></option>
                <% end %>
            </select>
        </div>

        <div class="day" >
            <select name="<%= @prefix <> "_day" %>">
                <option value="01" selected>Day (empty)</option>
                <%= for day <- 1..31 do %>
                    <option> <%= day %></option>
                <% end %>
            </select>
        </div>
    </div>



    """
  end
end
