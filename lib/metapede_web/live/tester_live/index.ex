defmodule MetapedeWeb.TesterLive.Test do
  use MetapedeWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(title: "My Searcher")}
  end

  def render(assigns) do
    ~L"""
    <h1><%= @title %></h1>
    """
  end
end
