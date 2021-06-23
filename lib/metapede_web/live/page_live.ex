defmodule MetapedeWeb.PageLive do
  use MetapedeWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
      <h1>Welcome to Metapede</h1>
      <div><%= live_redirect "Topics", to: Routes.topic_topics_path(@socket, :topics) %></div>
      <div><%= live_redirect "Time Periods", to: Routes.time_period_index_path(@socket, :main) %></div>
    """
  end

end
